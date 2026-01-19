import SwiftUI

enum Theme {
    static let fontTitle = Font.custom("Songti SC", size: 28)
    static func fontSubtitle(isDark: Bool) -> Font {
        Font.custom("-apple-system", size: isDark ? 13 : 14)
    }

    static func fontBody(isDark: Bool) -> Font {
        Font.custom("Songti SC", size: isDark ? 18 : 19)
    }

    static func fontCaption(isDark: Bool) -> Font {
        Font.custom("-apple-system", size: isDark ? 12 : 13)
    }

    static let spacingLarge: CGFloat = 32
    static let spacingMedium: CGFloat = 20
    static let spacingSmall: CGFloat = 12

    static let cornerRadius: CGFloat = 8
    static let borderWidth: CGFloat = 1

    static let transitionDuration: Double = 0.6

    static func backgroundColor(isDark: Bool) -> Color {
        isDark ? Color(hex: 0x1A1A1A) : Color(hex: 0xFCFBF9)
    }

    static func textColor(isDark: Bool) -> Color {
        isDark ? Color(hex: 0xF2F2F2) : Color(hex: 0x3D3D3D)
    }

    static func secondaryTextColor(isDark: Bool) -> Color {
        isDark ? Color(hex: 0xB3B3B3) : Color(hex: 0x969696)
    }

    static func highlightColor(isDark: Bool) -> Color {
        isDark ? Color(hex: 0x3C3C3C) : Color(hex: 0xD4D4D4)
    }

    static func cardBackground(isDark: Bool) -> Color {
        isDark ? Color(hex: 0x262626) : Color.white.opacity(0.5)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
