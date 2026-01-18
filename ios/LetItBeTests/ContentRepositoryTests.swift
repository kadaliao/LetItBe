import XCTest
@testable import LetItBeApp

final class ContentRepositoryTests: XCTestCase {
    func testLoadContentPayloadFromBundle() throws {
        let bundle = Bundle(for: ContentRepositoryTests.self)
        let repository = ContentRepository(bundle: bundle, resourceName: "content")
        let payload = try repository.load()
        XCTAssertFalse(payload.states.isEmpty)
        XCTAssertFalse(payload.cards.isEmpty)
    }

    func testRandomCardReturnsMatchingState() throws {
        let bundle = Bundle(for: ContentRepositoryTests.self)
        let repository = ContentRepository(bundle: bundle, resourceName: "content")
        let state = try repository.states().first
        XCTAssertNotNil(state)
        guard let state else { return }
        let card = try repository.randomCard(for: state)
        XCTAssertEqual(card.stateId, state.id)
    }
}
