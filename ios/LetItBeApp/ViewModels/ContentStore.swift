import Foundation

@Observable
final class ContentStore {
    private(set) var states: [MoodState] = []
    private(set) var currentState: MoodState?
    private(set) var currentCard: Card?
    private(set) var errorMessage: String?

    private let repository: ContentRepository
    // 抽卡簿记，不直接驱动 UI；标记 ignored 避免 body 内 peek 触发发布循环
    @ObservationIgnored private var decks: [String: [Card]] = [:]
    @ObservationIgnored private var history: [Card] = []

    var canGoBack: Bool { !history.isEmpty }

    init(repository: ContentRepository = ContentRepository()) {
        self.repository = repository
    }

    func loadIfNeeded() {
        guard states.isEmpty else { return }
        do {
            states = try repository.states()
            errorMessage = nil
        } catch {
            errorMessage = String(localized: "error_no_states")
        }
    }

    /// 启动时恢复上次的状态，直达卡片；没有记录则停留在首次选择。
    func restoreLastSession() {
        loadIfNeeded()
        guard currentState == nil,
              let key = SharedDefaults.lastState,
              let state = states.first(where: { $0.key == key }) else { return }
        currentState = state
        currentCard = draw(for: state)
    }

    func select(_ state: MoodState) {
        currentState = state
        SharedDefaults.lastState = state.key
        history.removeAll()
        currentCard = draw(for: state)
    }

    func nextCard() {
        guard let state = currentState else { return }
        if let card = currentCard {
            history.append(card)
            if history.count > 20 {
                history.removeFirst()
            }
        }
        currentCard = draw(for: state)
    }

    @discardableResult
    func previousCard() -> Bool {
        guard let last = history.popLast() else { return false }
        currentCard = last
        return true
    }

    /// 滑动预览：下一张会抽到的卡（不消耗），与随后的 nextCard() 结果一致。
    func peekNextCard() -> Card? {
        guard let state = currentState else { return nil }
        ensureDeck(for: state)
        return decks[state.id]?.last
    }

    /// 滑动预览：上一张卡（不消耗）。
    func peekPreviousCard() -> Card? {
        history.last
    }

    func card(withID id: String) -> Card? {
        (try? repository.load())?.cards.first { $0.id == id }
    }

    /// 深链 / 收藏跳转：直接展示某张卡，并切到它所属的状态。
    func show(cardID: String) {
        loadIfNeeded()
        guard let card = card(withID: cardID),
              let state = states.first(where: { $0.id == card.stateId }) else { return }
        if currentState?.id != state.id {
            currentState = state
            SharedDefaults.lastState = state.key
            history.removeAll()
        } else if let current = currentCard, current.id != card.id {
            history.append(current)
        }
        currentCard = card
    }

    /// 洗牌卡组抽卡：整组抽完才重洗，天然避免短期内重复。
    private func draw(for state: MoodState) -> Card? {
        ensureDeck(for: state)
        guard var deck = decks[state.id], !deck.isEmpty else {
            errorMessage = String(localized: "error_no_card")
            return nil
        }
        let card = deck.removeLast()
        decks[state.id] = deck
        errorMessage = nil
        return card
    }

    /// 卡组空了就重洗一副（重洗时把与当前卡相同的牌换到底部，避免连续重复）。
    private func ensureDeck(for state: MoodState) {
        guard (decks[state.id] ?? []).isEmpty else { return }
        guard let cards = try? repository.cards(for: state) else { return }
        var deck = cards.shuffled()
        if deck.count > 1, deck.last?.id == currentCard?.id {
            deck.swapAt(deck.count - 1, 0)
        }
        decks[state.id] = deck
    }
}
