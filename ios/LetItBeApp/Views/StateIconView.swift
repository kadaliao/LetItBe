import SwiftUI

struct StateIconView: View {
    let style: StateIconStyle
    let isSelected: Bool
    let isDark: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(Theme.highlightColor(isDark: isDark), lineWidth: Theme.borderWidth)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(isSelected ? Theme.textColor(isDark: isDark) : Theme.cardBackground(isDark: isDark))
                )

            icon
                .stroke(isSelected ? Theme.backgroundColor(isDark: isDark) : Theme.textColor(isDark: isDark), lineWidth: 1.5)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var icon: some Shape {
        switch style {
        case .tired:
            return AnyShape(FlowerIcon())
        case .numb:
            return AnyShape(VoidIcon())
        case .hide:
            return AnyShape(CaveIcon())
        case .annoyed:
            return AnyShape(NoiseIcon())
        }
    }
}

enum StateIconStyle {
    case tired
    case numb
    case hide
    case annoyed
}

struct FlowerIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let top = rect.minY + rect.height * 0.15
        let bottom = rect.maxY - rect.height * 0.1
        path.move(to: CGPoint(x: midX, y: top))
        path.addCurve(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.midY),
                      control1: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.35),
                      control2: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.midY))
        path.addCurve(to: CGPoint(x: midX, y: rect.maxY - rect.height * 0.25),
                      control1: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.maxY - rect.height * 0.1),
                      control2: CGPoint(x: midX, y: rect.maxY - rect.height * 0.15))
        path.move(to: CGPoint(x: midX, y: rect.minY + rect.height * 0.3))
        path.addCurve(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.midY),
                      control1: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY + rect.height * 0.4),
                      control2: CGPoint(x: rect.maxX - rect.width * 0.05, y: rect.midY))
        path.addCurve(to: CGPoint(x: midX, y: rect.maxY - rect.height * 0.25),
                      control1: CGPoint(x: rect.maxX - rect.width * 0.35, y: rect.maxY - rect.height * 0.05),
                      control2: CGPoint(x: midX, y: rect.maxY - rect.height * 0.2))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: bottom))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: bottom))
        return path
    }
}

struct VoidIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.35
        path.addArc(center: center, radius: radius, startAngle: .degrees(30), endAngle: .degrees(180), clockwise: false)
        path.addArc(center: center, radius: radius, startAngle: .degrees(210), endAngle: .degrees(330), clockwise: false)
        return path
    }
}

struct CaveIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.maxY - rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.maxY - rect.height * 0.15))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY - rect.height * 0.15))
        path.addCurve(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.maxY - rect.height * 0.15),
                      control1: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.midY),
                      control2: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.midY))
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.15))
        return path
    }
}

struct NoiseIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.5, y: rect.maxY - rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.7, y: rect.minY + rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY + rect.height * 0.45))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY + rect.height * 0.25))
        path.addCurve(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY + rect.height * 0.25),
                      control1: CGPoint(x: rect.midX - rect.width * 0.2, y: rect.minY + rect.height * 0.1),
                      control2: CGPoint(x: rect.midX + rect.width * 0.2, y: rect.minY + rect.height * 0.1))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.maxY - rect.height * 0.25))
        path.addCurve(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.maxY - rect.height * 0.25),
                      control1: CGPoint(x: rect.midX - rect.width * 0.2, y: rect.maxY - rect.height * 0.1),
                      control2: CGPoint(x: rect.midX + rect.width * 0.2, y: rect.maxY - rect.height * 0.1))
        return path
    }
}

struct AnyShape: Shape {
    private let pathBuilder: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}
