import Foundation

/// App 与 Widget 共享的轻量存储。仅存偏好与收藏 id，不存任何情绪数据。
enum SharedDefaults {
    static let appGroupID = "group.com.letitbe.app"

    static let lastStateKey = "last_state_key"
    static let favoriteCardIDsKey = "favorite_card_ids"
    static let widgetCardOffsetKey = "widget_card_offset"

    /// 无 App Group 权限（如个人开发签名）时自动降级到本地 defaults。
    static let store: UserDefaults = {
        if FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) != nil,
           let suite = UserDefaults(suiteName: appGroupID) {
            return suite
        }
        return .standard
    }()

    static var lastState: StateKey? {
        get {
            guard let raw = store.string(forKey: lastStateKey) else { return nil }
            return StateKey(rawValue: raw)
        }
        set {
            if let newValue {
                store.set(newValue.rawValue, forKey: lastStateKey)
            } else {
                store.removeObject(forKey: lastStateKey)
            }
        }
    }

    static var favoriteCardIDs: [String] {
        get { store.stringArray(forKey: favoriteCardIDsKey) ?? [] }
        set { store.set(newValue, forKey: favoriteCardIDsKey) }
    }

    /// Widget「换一条」按钮的换卡偏移，只在 widget 进程内自增。
    static var widgetCardOffset: Int {
        get { store.integer(forKey: widgetCardOffsetKey) }
        set { store.set(newValue, forKey: widgetCardOffsetKey) }
    }
}
