import SwiftUI

struct BreathingGuideView: View {
    let isDark: Bool
    @SwiftUI.State private var scale: CGFloat = 0.8
    @SwiftUI.State private var opacity: Double = 0.1

    var body: some View {
        Circle()
            .fill(Theme.highlightColor(isDark: isDark))
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    scale = 1.4
                    opacity = 0.3
                }
            }
    }
}
