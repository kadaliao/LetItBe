import SwiftUI
import Foundation

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: ThemeViewModel

    var body: some View {
        let isDark = theme.isDarkMode
        VStack(spacing: Theme.spacingLarge) {
            Circle()
                .strokeBorder(Theme.textColor(isDark: isDark), lineWidth: 2)
                .frame(width: 80, height: 80)
                .overlay(
                    Text("home_logo")
                        .font(Theme.fontTitle)
                        .themedTextColor(isDark: isDark)
                )
                .padding(.bottom, Theme.spacingLarge)

            Text("home_title")
                .font(Theme.fontTitle)
                .trackingCompat(8)
                .themedTextColor(isDark: isDark)

            Text("home_subtitle")
                .font(Theme.fontSubtitle(isDark: isDark))
                .textCase(.uppercase)
                .trackingCompat(4)
                .foregroundColor(Theme.secondaryTextColor(isDark: isDark))

            VStack(spacing: Theme.spacingSmall) {
                Button("home_primary_cta") {
                    appState.goToPicker()
                }
                .buttonStyle(PrimaryOutlineButtonStyle(isDark: isDark))
                .accessibilityIdentifier("home_primary_entry")
                .accessibilityLabel(String(localized: "home_primary_accessibility"))

                Button("home_quick_repair") {
                    quickRepair()
                }
                    .buttonStyle(LinkButtonStyle(isDark: isDark))
            }
            .padding(.top, Theme.spacingLarge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground(isDark: isDark)
        .animation(.easeInOut(duration: Theme.transitionDuration), value: isDark)
    }

    private func quickRepair() {
        let repository = ContentRepository()
        do {
            let states = try repository.states()
            guard let state = states.randomElement() else {
                appState.goToPicker()
                return
            }
            let card = try repository.randomCard(for: state)
            appState.goToStopLoss(card: card, state: state)
        } catch {
            appState.goToPicker()
        }
    }
}

struct PrimaryOutlineButtonStyle: ButtonStyle {
    let isDark: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.fontBody(isDark: isDark))
            .frame(maxWidth: 220)
            .padding(.vertical, 14)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Theme.textColor(isDark: isDark), lineWidth: 1)
            )
            .foregroundColor(Theme.textColor(isDark: isDark))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct LinkButtonStyle: ButtonStyle {
    let isDark: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.fontCaption(isDark: isDark))
            .foregroundColor(Theme.secondaryTextColor(isDark: isDark))
            .underlineCompat(color: Theme.secondaryTextColor(isDark: isDark))
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
