import SwiftUI

struct StatePickerView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: ThemeViewModel
    @StateObject private var viewModel: StatePickerViewModel

    init(viewModel: StatePickerViewModel = StatePickerViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let isDark = theme.isDarkMode
        VStack(spacing: Theme.spacingMedium) {
            Text("现在感觉如何？")
                .font(Theme.fontBody(isDark: isDark))
                .foregroundColor(Theme.secondaryTextColor(isDark: isDark))

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.spacingMedium) {
                stateCard(name: "累", subtitle: "能量枯竭", style: .tired, key: .tired, isDark: isDark)
                stateCard(name: "麻", subtitle: "麻木 · 空", style: .numb, key: .numb, isDark: isDark)
                stateCard(name: "躲", subtitle: "拖延 · 逃避", style: .hide, key: .hide, isDark: isDark)
                stateCard(name: "烦", subtitle: "焦虑 · 噪音", style: .annoyed, key: .annoyed, isDark: isDark)
            }
            .padding(.top, Theme.spacingMedium)

            Text("无需思考，直觉选择")
                .font(Theme.fontCaption(isDark: isDark))
                .tracking(3)
                .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
                .padding(.top, Theme.spacingLarge)
        }
        .padding(Theme.spacingLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground(isDark: isDark)
        .animation(.easeInOut(duration: Theme.transitionDuration), value: isDark)
        .onAppear {
            viewModel.loadStates()
        }
    }

    private func stateCard(name: String, subtitle: String, style: StateIconStyle, key: StateKey, isDark: Bool) -> some View {
        Button {
            if let state = viewModel.states.first(where: { $0.key == key }),
               let card = viewModel.randomCard(for: state) {
                appState.goToCard(card, state: state)
            } else {
                appState.goHome()
            }
        } label: {
            VStack(spacing: Theme.spacingSmall) {
                StateIconView(style: style, isSelected: false, isDark: isDark)
                    .frame(height: 90)

                Text(name)
                    .font(Theme.fontBody(isDark: isDark))
                    .tracking(4)
                    .foregroundColor(Theme.textColor(isDark: isDark))

                Text(subtitle)
                    .font(Theme.fontCaption(isDark: isDark))
                    .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
            }
            .padding(.vertical, Theme.spacingSmall)
            .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier("state_\(key.rawValue)")
        .accessibilityLabel("选择状态：\(name)")
    }
}
