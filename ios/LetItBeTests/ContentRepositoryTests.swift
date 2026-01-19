import XCTest
@testable import LetItBeApp

final class ContentRepositoryTests: XCTestCase {
    func testLoadContentPayloadFromBundle() throws {
        let repository = ContentRepository(bundle: Bundle(for: ContentRepository.self), resourceName: "content")
        let payload = try repository.load()
        XCTAssertFalse(payload.states.isEmpty)
        XCTAssertFalse(payload.cards.isEmpty)
    }

    func testRandomCardReturnsMatchingState() throws {
        let repository = ContentRepository(bundle: Bundle(for: ContentRepository.self), resourceName: "content")
        let state = try repository.states().first
        XCTAssertNotNil(state)
        guard let state else { return }
        let card = try repository.randomCard(for: state)
        XCTAssertEqual(card.stateId, state.id)
    }
}
