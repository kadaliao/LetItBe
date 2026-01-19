import SwiftUI

struct TopControlsView: View {
    @EnvironmentObject private var theme: ThemeViewModel

    var body: some View {
        HStack {
            Spacer()
            Button("◑") {
                theme.toggle()
            }
            .font(Theme.fontBody(isDark: theme.isDarkMode))
            .foregroundColor(Theme.textColor(isDark: theme.isDarkMode))
            .accessibilityIdentifier("theme_toggle")
        }
    }
}
