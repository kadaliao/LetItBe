import SwiftUI
import Combine

@main
struct LetItBeApp: App {
    @State private var content: ContentStore
    @State private var favorites: FavoritesStore
    @State private var appearance: AppearanceModel
    @State private var now = Date()

    private let minuteTick = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    init() {
        UITestSupport.configureIfNeeded()
        _content = State(wrappedValue: ContentStore())
        _favorites = State(wrappedValue: FavoritesStore())
        _appearance = State(wrappedValue: AppearanceModel())
    }

    private var nightActive: Bool {
        appearance.nightDimEnabled && NightDim.isNight(now)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(content)
                .environment(favorites)
                .environment(appearance)
                .environment(\.nightDim, nightActive)
                .nightDimOverlay()
                .preferredColorScheme(nightActive ? .dark : appearance.mode.colorScheme)
                .onReceive(minuteTick) { date in
                    now = date
                }
        }
    }
}

struct RootView: View {
    @Environment(ContentStore.self) private var content

    var body: some View {
        ZStack {
            if content.currentState == nil {
                FirstRunView()
                    .transition(.opacity)
            } else {
                MainCardView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: Theme.transitionDuration), value: content.currentState == nil)
        .onAppear {
            content.restoreLastSession()
        }
        .onOpenURL { url in
            guard url.scheme == "letitbe", url.host == "card" else { return }
            let cardID = url.lastPathComponent
            guard !cardID.isEmpty else { return }
            content.show(cardID: cardID)
        }
        .onReceive(NotificationCenter.default.publisher(for: .letItBeDrawNewCard)) { _ in
            // Siri「我想摆烂」：已在卡片页则直接换一张新的
            if content.currentState != nil {
                content.nextCard()
            }
        }
    }
}

enum UITestSupport {
    static func configureIfNeeded() {
        let args = ProcessInfo.processInfo.arguments
        guard args.contains("-ui-testing") else { return }
        SharedDefaults.lastState = nil
        SharedDefaults.favoriteCardIDs = []
        UserDefaults.standard.removeObject(forKey: "appearance_mode")
        UserDefaults.standard.removeObject(forKey: "swipe_hint_count")
        // UI 测试不受运行时刻影响：夜间降噪固定关闭
        UserDefaults.standard.set(false, forKey: "night_dim_enabled")
        if let index = args.firstIndex(of: "-ui-testing-state"),
           args.indices.contains(index + 1),
           let key = StateKey(rawValue: args[index + 1]) {
            SharedDefaults.lastState = key
        }
    }
}
