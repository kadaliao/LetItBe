import Foundation

final class CardViewModel: ObservableObject {
    @Published private(set) var card: Card?
    @Published private(set) var errorMessage: String?

    private let repository: ContentRepository
    private var lastCardId: String?

    init(repository: ContentRepository = ContentRepository()) {
        self.repository = repository
    }

    func loadInitialCard(state: State, initialCard: Card?) {
        if let initialCard {
            card = initialCard
            lastCardId = initialCard.id
            errorMessage = nil
            return
        }
        card = fetchCard(for: state)
    }

    func nextCard(state: State) {
        guard let next = fetchCard(for: state) else {
            errorMessage = String(localized: "error_no_new_card")
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
            errorMessage = String(localized: "error_no_card")
            return nil
        }
    }
}
