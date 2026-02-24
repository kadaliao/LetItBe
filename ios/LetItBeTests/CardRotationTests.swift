import XCTest
@testable import LetItBeApp

final class CardRotationTests: XCTestCase {
    func testNextCardAvoidsImmediateRepeatWhenPossible() throws {
        let bundle = Bundle(for: CardRotationTests.self)
        let repository = ContentRepository(bundle: bundle, resourceName: "content")
        let viewModel = CardViewModel(repository: repository)

        let state = State(id: "state_tired", key: .tired, name: "累", description: nil)
        viewModel.loadInitialCard(state: state, initialCard: nil)
        let first = viewModel.card
        viewModel.nextCard(state: state)
        let second = viewModel.card

        if let first, let second, repositoryHasMultipleCards(for: state, repository: repository) {
            XCTAssertNotEqual(first.id, second.id)
        }
    }

    private func repositoryHasMultipleCards(for state: State, repository: ContentRepository) -> Bool {
        if let cards = try? repository.cards(for: state) {
            return cards.count > 1
        }
        return false
    }
}
