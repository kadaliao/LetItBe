import SwiftUI

enum Theme {
    // MARK: - Typography（宋体纸感 + Dynamic Type）

    static let fontTitle = Font.custom("Songti SC", size: 28, relativeTo: .title)
    static let fontBody = Font.custom("Songti SC", size: 19, relativeTo: .body)
    static let fontCardTitle = Font.custom("Songti SC", size: 22, relativeTo: .title3)
    static let fontSubtitle = Font.system(size: 14, design: .default)
    static let fontCaption = Font.system(size: 13, design: .default)

    // MARK: - Layout

    static let spacingLarge: CGFloat = 32
    static let spacingMedium: CGFloat = 20
    static let spacingSmall: CGFloat = 12

    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1

    static let transitionDuration: Double = 0.45

    // MARK: - Semantic colors

    static func backgroundColor(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: 0x1A1A1A) : Color(hex: 0xFCFBF9)
    }

    static func textColor(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: 0xF2F2F2) : Color(hex: 0x3D3D3D)
    }

    static func secondaryTextColor(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: 0xB3B3B3) : Color(hex: 0x969696)
    }

    static func highlightColor(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: 0x3C3C3C) : Color(hex: 0xD4D4D4)
    }

    static func cardBackground(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: 0x262626) : Color.white.opacity(0.6)
    }

    static func cardShadow(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.black.opacity(0.35) : Color(hex: 0x8A8272).opacity(0.14)
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

// MARK: - Appearance

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var labelKey: LocalizedStringKey {
        switch self {
        case .system: return "appearance_system"
        case .light: return "appearance_light"
        case .dark: return "appearance_dark"
        }
    }
}

@Observable
final class AppearanceModel {
    private static let modeKey = "appearance_mode"
    private static let legacyDarkKey = "letitbe_dark_mode"

    var mode: AppearanceMode {
        didSet { UserDefaults.standard.set(mode.rawValue, forKey: Self.modeKey) }
    }

    init(defaults: UserDefaults = .standard) {
        if let raw = defaults.string(forKey: Self.modeKey), let stored = AppearanceMode(rawValue: raw) {
            mode = stored
        } else if defaults.object(forKey: Self.legacyDarkKey) != nil {
            // 迁移 v1 的手动暗色开关：开着 → 暗色，关着 → 跟随系统
            mode = defaults.bool(forKey: Self.legacyDarkKey) ? .dark : .system
            defaults.removeObject(forKey: Self.legacyDarkKey)
        } else {
            mode = .system
        }
    }
}
