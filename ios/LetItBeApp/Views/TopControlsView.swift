import SwiftUI
import UIKit

struct TopControlsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: ThemeViewModel
    @SwiftUI.State private var isSaving = false
    @SwiftUI.State private var isPreparingPreview = false
    @SwiftUI.State private var alertMessage: String?
    @SwiftUI.State private var isAlertPresented = false
    @SwiftUI.State private var isPreviewPresented = false
    @SwiftUI.State private var previewImage: UIImage?

    var body: some View {
        HStack(spacing: Theme.spacingSmall) {
            Spacer()
            if appState.route == .card {
                if isSaving || isPreparingPreview {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(Theme.textColor(isDark: theme.isDarkMode))
                        .accessibilityIdentifier("share_saving")
                } else {
                    Button {
                        prepareSharePreview()
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
        .sheet(isPresented: $isPreviewPresented) {
            SharePreviewSheet(
                image: previewImage,
                isDark: theme.isDarkMode,
                isSaving: isSaving,
                onCancel: {
                    previewImage = nil
                    isPreviewPresented = false
                },
                onSave: {
                    confirmShareSave()
                }
            )
        }
    }

    private func prepareSharePreview() {
        guard !isPreparingPreview, !isSaving else { return }
        guard let card = appState.currentCard, let state = appState.selectedState else { return }
        isPreparingPreview = true
        Task {
            let result = await ShareImageService.makeShareImage(card: card, state: state, isDark: theme.isDarkMode)
            await MainActor.run {
                isPreparingPreview = false
                switch result {
                case .success(let image):
                    previewImage = image
                    isPreviewPresented = true
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    isAlertPresented = true
                }
            }
        }
    }

    private func confirmShareSave() {
        guard !isSaving, let previewImage else { return }
        isSaving = true
        Task {
            let result = await ShareImageService.saveShareImage(previewImage)
            await MainActor.run {
                isSaving = false
                switch result {
                case .success:
                    alertMessage = String(localized: "share_saved")
                    self.previewImage = nil
                    isPreviewPresented = false
                case .failure(let error):
                    alertMessage = error.localizedDescription
                }
                isAlertPresented = true
            }
        }
    }
}

private struct SharePreviewSheet: View {
    let image: UIImage?
    let isDark: Bool
    let isSaving: Bool
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        ZStack {
            previewBackground
                .ignoresSafeArea()

            VStack(spacing: Theme.spacingMedium) {
                Text("share_preview_title")
                    .font(Theme.fontBody(isDark: isDark))
                    .themedTextColor(isDark: isDark)

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .stroke(Theme.highlightColor(isDark: isDark), lineWidth: Theme.borderWidth)
                        )
                } else {
                    ProgressView()
                        .tint(Theme.textColor(isDark: isDark))
                }

                HStack(spacing: Theme.spacingSmall) {
                    Button("share_preview_cancel") {
                        onCancel()
                    }
                    .buttonStyle(LinkButtonStyle(isDark: isDark))
                    .disabled(isSaving)

                    Button {
                        onSave()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .tint(Theme.textColor(isDark: isDark))
                        } else {
                            Text("share_preview_save")
                        }
                    }
                    .buttonStyle(PrimaryOutlineButtonStyle(isDark: isDark))
                    .disabled(isSaving || image == nil)
                }
            }
            .padding(Theme.spacingLarge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var previewBackground: LinearGradient {
        let start = isDark ? Color(hex: 0x121212) : Color(hex: 0xF4EEE7)
        let end = isDark ? Color(hex: 0x1C1C1C) : Color(hex: 0xFFFFFF)
        return LinearGradient(colors: [start, end], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
