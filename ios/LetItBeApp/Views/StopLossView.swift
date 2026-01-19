import SwiftUI

struct StopLossView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: ThemeViewModel
    @StateObject private var viewModel: StopLossViewModel

    init(viewModel: StopLossViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: StopLossView.makeDefaultViewModel())
        }
    }

    var body: some View {
        let isDark = theme.isDarkMode
        VStack(spacing: Theme.spacingMedium) {
            ZStack {
                BreathingGuideView(isDark: isDark)
                    .frame(width: 200, height: 200)

                VStack(spacing: Theme.spacingSmall) {
                    Text("呼吸")
                        .font(Theme.fontBody(isDark: isDark))
                        .themedTextColor(isDark: isDark)

                    Text(timeString(from: viewModel.remainingSeconds))
                        .font(.system(size: 48, weight: .light, design: .rounded))
                        .foregroundColor(Theme.textColor(isDark: isDark))
                        .accessibilityIdentifier("stoploss_timer")

                    Text(viewModel.isInhaling ? "吸气…" : "呼气…")
                        .font(Theme.fontCaption(isDark: isDark))
                        .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
                }
            }
            .padding(.vertical, Theme.spacingLarge)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
            }

            Button(viewModel.isRunning ? "正在进行..." : "开始") {
                startIfNeeded()
            }
            .buttonStyle(PrimaryOutlineButtonStyle(isDark: isDark))
            .disabled(viewModel.isRunning)
            .accessibilityIdentifier("stoploss_start")
            .accessibilityLabel("开始修复计时")

            Button("结束") {
                stopAndReturn()
            }
            .buttonStyle(LinkButtonStyle(isDark: isDark))
            .accessibilityIdentifier("stoploss_exit")
            .accessibilityLabel("结束修复并返回主页")
        }
        .padding(Theme.spacingLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground(isDark: isDark)
        .animation(.easeInOut(duration: Theme.transitionDuration), value: isDark)
        .onAppear {
            startIfNeeded()
        }
        .onChange(of: viewModel.didComplete) { didComplete in
            if didComplete {
                appState.goHome()
            }
        }
    }

    private func startIfNeeded() {
        guard !viewModel.isRunning else { return }
        guard let card = appState.currentCard, let state = appState.selectedState else {
            appState.goHome()
            return
        }
        viewModel.start(card: card, state: state)
    }

    private func stopAndReturn() {
        viewModel.stop(reason: .canceled)
        appState.goHome()
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return String(format: "%02d:%02d", minutes, remaining)
    }
}

private extension StopLossView {
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
