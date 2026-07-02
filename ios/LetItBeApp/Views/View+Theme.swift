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
