import SwiftUI

extension View {
    func themedBackground(isDark: Bool) -> some View {
        self.background(Theme.backgroundColor(isDark: isDark))
    }

    func themedTextColor(isDark: Bool) -> some View {
        self.foregroundColor(Theme.textColor(isDark: isDark))
    }

    @ViewBuilder
    func trackingCompat(_ value: CGFloat) -> some View {
        if #available(iOS 16.0, *) {
            self.tracking(value)
        } else {
            self
        }
    }

    @ViewBuilder
    func underlineCompat(color: Color) -> some View {
        if #available(iOS 16.0, *) {
            self.underline(true, color: color)
        } else {
            self.overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(color),
                alignment: .bottom
            )
        }
    }
}
