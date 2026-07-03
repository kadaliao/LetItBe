import SwiftUI

extension StateKey {
    var iconStyle: StateIconStyle {
        switch self {
        case .tired: return .tired
        case .numb: return .numb
        case .hide: return .hide
        case .annoyed: return .annoyed
        }
    }
}

// MARK: - 睡前降噪环境

private struct NightDimEnvironmentKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var nightDim: Bool {
        get { self[NightDimEnvironmentKey.self] }
        set { self[NightDimEnvironmentKey.self] = newValue }
    }
}

/// 深夜窗口内给整块界面盖一层均匀的压暗，文字对比一起降，像把灯调暗。
private struct NightDimModifier: ViewModifier {
    @Environment(\.nightDim) private var nightDim

    func body(content: Content) -> some View {
        content.overlay {
            if nightDim {
                Color.black.opacity(0.22)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }
        }
    }
}

extension View {
    func nightDimOverlay() -> some View {
        modifier(NightDimModifier())
    }
}
