import SwiftUI

struct TopControlsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: ThemeViewModel
    @State private var isSaving = false
    @State private var alertMessage: String?
    @State private var isAlertPresented = false

    var body: some View {
        HStack(spacing: Theme.spacingSmall) {
            Spacer()
            if appState.route == .card {
                if isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(Theme.textColor(isDark: theme.isDarkMode))
                        .accessibilityIdentifier("share_saving")
                } else {
                    Button {
                        saveShareImage()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Theme.textColor(isDark: theme.isDarkMode))
                    .accessibilityIdentifier("card_share")
                    .accessibilityLabel(String(localized: "card_share_accessibility"))
                }
            }
            Button("◑") {
                theme.toggle()
            }
            .font(Theme.fontBody(isDark: theme.isDarkMode))
            .foregroundColor(Theme.textColor(isDark: theme.isDarkMode))
            .accessibilityIdentifier("theme_toggle")
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text(alertMessage ?? ""),
                dismissButton: .default(Text(String(localized: "common_ok")))
            )
        }
    }

    private func saveShareImage() {
        guard let card = appState.currentCard, let state = appState.selectedState else { return }
        isSaving = true
        Task {
            let result = await ShareImageService.saveShareImage(card: card, state: state, isDark: theme.isDarkMode)
            await MainActor.run {
                isSaving = false
                switch result {
                case .success:
                    alertMessage = String(localized: "share_saved")
                case .failure(let error):
                    alertMessage = error.localizedDescription
                }
                isAlertPresented = true
            }
        }
    }
}
