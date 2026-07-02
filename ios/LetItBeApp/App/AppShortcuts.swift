import AppIntents
import Foundation

/// Siri / 快捷指令：「我想摆烂」→ 打开 App 并抽一张新卡。
struct OpenCardIntent: AppIntent {
    static var title: LocalizedStringResource = "intent_open_card_title"
    static var description = IntentDescription("intent_open_card_desc")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: .letItBeDrawNewCard, object: nil)
        return .result()
    }
}

extension Notification.Name {
    static let letItBeDrawNewCard = Notification.Name("letitbe.draw_new_card")
}

struct LetItBeAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenCardIntent(),
            phrases: [
                "我想摆烂 \(.applicationName)",
                "\(.applicationName) 我想摆烂",
                "用 \(.applicationName) 来一句",
                "One line from \(.applicationName)",
                "\(.applicationName), let me be"
            ],
            shortTitle: "intent_open_card_title",
            systemImageName: "moon.zzz"
        )
    }
}
