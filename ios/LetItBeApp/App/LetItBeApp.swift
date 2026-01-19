import SwiftUI

@main
struct LetItBeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appState = AppState()
    @StateObject private var theme = ThemeViewModel()
    private let isUITesting = ProcessInfo.processInfo.arguments.contains("-ui-testing")

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .topTrailing) {
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

                if appState.route != .stopLoss {
                    TopControlsView()
                        .padding(.top, Theme.spacingLarge)
                        .padding(.trailing, Theme.spacingLarge)
                }
            }
            .environmentObject(appState)
            .environmentObject(theme)
            .onAppear {
                if isUITesting {
                    appState.goHome()
                }
            }
            .onChange(of: scenePhase) { phase in
                if isUITesting && phase == .active {
                    appState.goHome()
                }
            }
        }
    }
}
