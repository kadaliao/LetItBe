import SwiftUI

@main
struct LetItBeApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.route {
                case .home:
                    HomeView()
                case .picker:
                    StatePickerView()
                case .card:
                    CardView()
                case .stopLoss:
                    StopLossView()
                }
            }
            .environmentObject(appState)
        }
    }
}
