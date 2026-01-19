import Foundation
import SwiftUI

final class ThemeViewModel: ObservableObject {
    @AppStorage("letitbe_dark_mode") var isDarkMode: Bool = false

    func toggle() {
        isDarkMode.toggle()
    }
}
