import Foundation

final class CardViewModel: ObservableObject {
    @Published private(set) var card: Card?
    @Published private(set) var errorMessage: String?

    private let repository: ContentRepository
    private var lastCardId: String?

    init(repository: ContentRepository = ContentRepository()) {
        self.repository = repository
    }

    func loadInitialCard(state: State) {
        card = fetchCard(for: state)
    }

    func nextCard(state: State) {
        guard let next = fetchCard(for: state) else {
            errorMessage = "暂时没有新的卡片"
            return
        }
        card = next
    }

    private func fetchCard(for state: State) -> Card? {
        do {
            let cards = try repository.cards(for: state)
            if cards.count == 1 {
                lastCardId = cards.first?.id
                return cards.first
            }
            var candidate = cards.randomElement()
            if let lastId = lastCardId {
                for _ in 0..<3 {
                    if candidate?.id != lastId { break }
                    candidate = cards.randomElement()
                }
            }
            lastCardId = candidate?.id
            errorMessage = nil
            return candidate
        } catch {
            errorMessage = "暂时没有可用卡片"
            return nil
        }
    }
}
