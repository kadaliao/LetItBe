import SwiftUI

struct CardView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: ThemeViewModel
    @StateObject private var viewModel: CardViewModel

    init(viewModel: CardViewModel = CardViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let isDark = theme.isDarkMode
        let style = CardStyle(isDark: isDark)
        VStack(spacing: Theme.spacingMedium) {
            if let card = viewModel.card {
                VStack(spacing: Theme.spacingMedium) {
                    Text(card.title)
                        .font(style.titleFont)
                        .accessibilityIdentifier("card_title")

                    Text(card.body)
                        .font(style.bodyFont)
                        .multilineTextAlignment(.leading)
                        .accessibilityIdentifier("card_body")

                    Text(card.footer)
                        .font(style.footerFont)
                        .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
                        .accessibilityIdentifier("card_footer")
                }
                .themedTextColor(isDark: isDark)
                .padding(Theme.spacingMedium)
                .frame(maxWidth: 360)
                .background(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .fill(style.background)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .stroke(style.borderColor, lineWidth: Theme.borderWidth)
                )

                HStack(spacing: Theme.spacingSmall) {
                    Button("修复一下") {
                        appState.goToStopLoss()
                    }
                    .buttonStyle(PrimaryOutlineButtonStyle(isDark: isDark))
                    .accessibilityIdentifier("stop_loss_entry")
                    .accessibilityLabel("进入修复计时")

                    Button("换一条") {
                        if let state = appState.selectedState {
                            viewModel.nextCard(state: state)
                        }
                    }
                    .buttonStyle(PrimaryOutlineButtonStyle(isDark: isDark))
                    .accessibilityIdentifier("card_swap")
                    .accessibilityLabel("切换到另一条卡片")
                }
                .frame(maxWidth: 360)
            } else {
                Text(viewModel.errorMessage ?? "暂无内容")
                    .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
            }
        }
        .padding(Theme.spacingLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground(isDark: isDark)
        .animation(.easeInOut(duration: Theme.transitionDuration), value: isDark)
        .onAppear {
            if let state = appState.selectedState {
                viewModel.loadInitialCard(state: state)
            }
        }
    }
}
