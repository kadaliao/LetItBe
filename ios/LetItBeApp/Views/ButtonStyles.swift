import SwiftUI
import UIKit

struct PrimaryOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        StyledLabel(configuration: configuration)
    }

    private struct StyledLabel: View {
        @Environment(\.colorScheme) private var scheme
        let configuration: Configuration

        var body: some View {
            configuration.label
                .font(Theme.fontBody)
                .frame(maxWidth: 220)
                .padding(.vertical, 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Theme.textColor(scheme), lineWidth: 1)
                )
                .foregroundColor(Theme.textColor(scheme))
                .opacity(configuration.isPressed ? 0.6 : 1)
                .scaleEffect(configuration.isPressed ? 0.98 : 1)
                .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
        }
    }
}

struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        StyledLabel(configuration: configuration)
    }

    private struct StyledLabel: View {
        @Environment(\.colorScheme) private var scheme
        let configuration: Configuration

        var body: some View {
            configuration.label
                .font(Theme.fontCaption)
                .foregroundColor(Theme.secondaryTextColor(scheme))
                .underline(true, color: Theme.secondaryTextColor(scheme))
                .opacity(configuration.isPressed ? 0.6 : 1)
        }
    }
}

enum Haptics {
    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
