import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    Circle()
                        .strokeBorder(Theme.textColor(scheme), lineWidth: 2)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text("home_logo")
                                .font(Theme.fontTitle)
                                .foregroundColor(Theme.textColor(scheme))
                        )
                        .padding(.top, Theme.spacingLarge)

                    VStack(spacing: Theme.spacingSmall) {
                        Text("home_title")
                            .font(Theme.fontTitle)
                            .tracking(8)
                            .foregroundColor(Theme.textColor(scheme))

                        Text("home_subtitle")
                            .font(Theme.fontSubtitle)
                            .textCase(.uppercase)
                            .tracking(4)
                            .foregroundColor(Theme.secondaryTextColor(scheme))
                    }

                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        aboutSection(titleKey: "about_position_title", bodyKey: "about_position_body")
                        aboutSection(titleKey: "about_disclaimer_title", bodyKey: "about_disclaimer_body")
                        aboutSection(titleKey: "about_privacy_title", bodyKey: "about_privacy_body")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(versionText)
                        .font(Theme.fontCaption)
                        .foregroundColor(Theme.secondaryTextColor(scheme).opacity(0.7))
                        .padding(.bottom, Theme.spacingLarge)
                }
                .padding(.horizontal, Theme.spacingLarge)
            }
            .background(Theme.backgroundColor(scheme))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("common_done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.textColor(scheme))
                    .accessibilityIdentifier("about_done")
                }
            }
        }
    }

    private func aboutSection(titleKey: LocalizedStringKey, bodyKey: LocalizedStringKey) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
            Text(titleKey)
                .font(Theme.fontBody)
                .foregroundColor(Theme.textColor(scheme))

            Text(bodyKey)
                .font(Theme.fontCaption)
                .foregroundColor(Theme.secondaryTextColor(scheme))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var versionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        return "v\(version) (\(build))"
    }
}
