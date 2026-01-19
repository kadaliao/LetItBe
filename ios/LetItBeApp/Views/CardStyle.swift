import SwiftUI

struct CardStyle {
    let isDark: Bool

    var background: Color {
        Theme.cardBackground(isDark: isDark)
    }

    var borderColor: Color {
        Theme.highlightColor(isDark: isDark)
    }

    var titleFont: Font { Theme.fontBody(isDark: isDark) }
    var bodyFont: Font { Theme.fontBody(isDark: isDark) }
    var footerFont: Font { Theme.fontCaption(isDark: isDark) }
}
