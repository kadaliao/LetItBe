import SwiftUI

/// 止损/修复页：呼吸计时 + 极简清单，两种低成本动作。
struct RepairView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ContentStore.self) private var content
    @Environment(\.colorScheme) private var scheme

    @State private var viewModel = RepairView.makeDefaultViewModel()
    @State private var mode: RepairMode = .breathing
    @State private var checkedItems: Set<String> = []

    enum RepairMode: String, CaseIterable, Identifiable {
        case breathing
        case checklist

        var id: String { rawValue }

        var labelKey: LocalizedStringKey {
            switch self {
            case .breathing: return "repair_breathing_tab"
            case .checklist: return "repair_checklist_tab"
            }
        }
    }

    private let checklistItems = ["checklist_water", "checklist_face", "checklist_window"]

    var body: some View {
        VStack(spacing: Theme.spacingMedium) {
            modeTabs
                .padding(.top, Theme.spacingLarge)

            Spacer()

            switch mode {
            case .breathing:
                breathingContent
            case .checklist:
                checklistContent
            }

            Spacer()

            exitButton
                .padding(.bottom, Theme.spacingLarge)
        }
        .padding(Theme.spacingLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor(scheme))
        .onChange(of: viewModel.isInhaling) {
            if viewModel.phase == .running {
                Haptics.soft()
            }
        }
        .onChange(of: viewModel.phase) {
            if viewModel.phase == .finished {
                Haptics.success()
            }
        }
        .onDisappear {
            viewModel.cancelIfRunning()
        }
    }

    // MARK: - Tabs

    private var modeTabs: some View {
        HStack(spacing: Theme.spacingLarge) {
            ForEach(RepairMode.allCases) { tab in
                let isSelected = mode == tab
                Button {
                    guard mode != tab else { return }
                    Haptics.selection()
                    viewModel.cancelIfRunning()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        mode = tab
                    }
                } label: {
                    VStack(spacing: 5) {
                        Text(tab.labelKey)
                            .font(Theme.fontBody)
                            .foregroundColor(isSelected ? Theme.textColor(scheme) : Theme.secondaryTextColor(scheme).opacity(0.7))

                        Circle()
                            .fill(Theme.textColor(scheme))
                            .frame(width: 4, height: 4)
                            .opacity(isSelected ? 1 : 0)
                    }
                }
                .accessibilityIdentifier("repair_tab_\(tab.rawValue)")
            }
        }
    }

    // MARK: - Breathing

    @ViewBuilder
    private var breathingContent: some View {
        ZStack {
            breathingCircle
                .frame(width: 220, height: 220)

            VStack(spacing: Theme.spacingSmall) {
                switch viewModel.phase {
                case .finished:
                    Text("stoploss_done")
                        .font(Theme.fontBody)
                        .foregroundColor(Theme.textColor(scheme))
                default:
                    Text(timeString(from: viewModel.remainingSeconds))
                        .font(.system(size: 44, weight: .light, design: .rounded))
                        .foregroundColor(Theme.textColor(scheme))
                        .accessibilityIdentifier("stoploss_timer")

                    Text(breathLabelKey)
                        .font(Theme.fontCaption)
                        .foregroundColor(Theme.secondaryTextColor(scheme))
                }
            }
        }
        .padding(.vertical, Theme.spacingLarge)

        if let error = viewModel.errorMessage {
            Text(error)
                .font(Theme.fontCaption)
                .foregroundColor(Theme.secondaryTextColor(scheme))
        }

        switch viewModel.phase {
        case .idle:
            durationChips
                .padding(.bottom, Theme.spacingSmall)

            Button("stoploss_start") {
                startBreathing()
            }
            .buttonStyle(PrimaryOutlineButtonStyle())
            .accessibilityIdentifier("stoploss_start")
            .accessibilityLabel(String(localized: "stoploss_start_accessibility"))
        case .running:
            Text("stoploss_running")
                .font(Theme.fontCaption)
                .foregroundColor(Theme.secondaryTextColor(scheme))
                .padding(.vertical, 14)
        case .finished:
            Button("stoploss_back") {
                dismiss()
            }
            .buttonStyle(PrimaryOutlineButtonStyle())
            .accessibilityIdentifier("stoploss_back")
        }
    }

    private var breathingCircle: some View {
        let isRunning = viewModel.phase == .running
        let scale: CGFloat = isRunning ? (viewModel.isInhaling ? 1.25 : 0.8) : 1.0
        return Circle()
            .fill(Theme.highlightColor(scheme).opacity(isRunning ? 0.5 : 0.3))
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 4), value: viewModel.isInhaling)
            .animation(.easeInOut(duration: 0.8), value: viewModel.phase == .running)
    }

    private var breathLabelKey: LocalizedStringKey {
        switch viewModel.phase {
        case .running:
            return viewModel.isInhaling ? "stoploss_inhale" : "stoploss_exhale"
        default:
            return "stoploss_breathe"
        }
    }

    private var durationChips: some View {
        HStack(spacing: Theme.spacingSmall) {
            durationChip(seconds: 60, labelKey: "duration_1min")
            durationChip(seconds: 120, labelKey: "duration_2min")
            durationChip(seconds: 300, labelKey: "duration_5min")
        }
    }

    private func durationChip(seconds: Int, labelKey: LocalizedStringKey) -> some View {
        let isSelected = viewModel.selectedDuration == seconds
        return Button {
            Haptics.selection()
            viewModel.selectedDuration = seconds
        } label: {
            Text(labelKey)
                .font(Theme.fontCaption)
                .foregroundColor(isSelected ? Theme.backgroundColor(scheme) : Theme.secondaryTextColor(scheme))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected ? Theme.textColor(scheme) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Theme.highlightColor(scheme), lineWidth: Theme.borderWidth)
                )
        }
        .accessibilityIdentifier("duration_\(seconds)")
    }

    private func startBreathing() {
        guard let card = content.currentCard, let state = content.currentState else {
            dismiss()
            return
        }
        viewModel.start(card: card, state: state)
    }

    // MARK: - Checklist

    @ViewBuilder
    private var checklistContent: some View {
        VStack(spacing: Theme.spacingMedium) {
            ForEach(checklistItems, id: \.self) { item in
                checklistRow(item)
            }
        }
        .frame(maxWidth: 300)

        Text("checklist_hint")
            .font(Theme.fontCaption)
            .foregroundColor(Theme.secondaryTextColor(scheme))
            .padding(.top, Theme.spacingLarge)
    }

    private func checklistRow(_ item: String) -> some View {
        let isChecked = checkedItems.contains(item)
        return Button {
            Haptics.light()
            if isChecked {
                checkedItems.remove(item)
            } else {
                checkedItems.insert(item)
            }
        } label: {
            HStack(spacing: Theme.spacingSmall) {
                Image(systemName: isChecked ? "circle.fill" : "circle")
                    .font(.system(size: 12))
                    .foregroundColor(isChecked ? Theme.textColor(scheme) : Theme.secondaryTextColor(scheme).opacity(0.6))

                Text(LocalizedStringKey(item))
                    .font(Theme.fontBody)
                    .foregroundColor(Theme.textColor(scheme))
                    .strikethrough(isChecked, color: Theme.secondaryTextColor(scheme))
                    .opacity(isChecked ? 0.55 : 1)

                Spacer()
            }
            .padding(.vertical, 6)
        }
        .accessibilityIdentifier("checklist_\(item)")
    }

    // MARK: - Exit

    private var exitButton: some View {
        Button("stoploss_end") {
            finishAndDismiss()
        }
        .buttonStyle(LinkButtonStyle())
        .accessibilityIdentifier("stoploss_exit")
        .accessibilityLabel(String(localized: "stoploss_end_accessibility"))
    }

    private func finishAndDismiss() {
        switch mode {
        case .breathing:
            viewModel.cancelIfRunning()
        case .checklist:
            if !checkedItems.isEmpty, let card = content.currentCard, let state = content.currentState {
                viewModel.recordChecklist(card: card, state: state)
            }
        }
        dismiss()
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return String(format: "%02d:%02d", minutes, remaining)
    }
}

private extension RepairView {
    static func makeDefaultViewModel() -> StopLossViewModel {
        do {
            let store = try SQLiteStore(databaseName: "letitbe")
            let repository = try StopLossRepository(store: store)
            let service = StopLossService(repository: repository)
            return StopLossViewModel(service: service)
        } catch {
            let repository = InMemoryStopLossRepository()
            let service = StopLossService(repository: repository)
            return StopLossViewModel(service: service)
        }
    }
}
