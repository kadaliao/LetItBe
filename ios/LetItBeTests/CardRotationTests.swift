import XCTest
@testable import LetItBeApp

final class CardRotationTests: XCTestCase {
    private func makeStore() -> ContentStore {
        let bundle = Bundle(for: CardRotationTests.self)
        let repository = ContentRepository(bundle: bundle, resourceName: "content")
        return ContentStore(repository: repository)
    }

    func testSelectStateDrawsCardOfThatState() throws {
        let store = makeStore()
        store.loadIfNeeded()
        let state = try XCTUnwrap(store.states.first)

        store.select(state)

        let card = try XCTUnwrap(store.currentCard)
        XCTAssertEqual(card.stateId, state.id)
    }

    func testDeckAvoidsImmediateRepeat() throws {
        let store = makeStore()
        store.loadIfNeeded()
        let state = try XCTUnwrap(store.states.first)
        store.select(state)

        var previousID = try XCTUnwrap(store.currentCard).id
        for _ in 0..<10 {
            store.nextCard()
            let currentID = try XCTUnwrap(store.currentCard).id
            XCTAssertNotEqual(currentID, previousID)
            previousID = currentID
        }
    }

    func testPreviousCardRestoresHistory() throws {
        let store = makeStore()
        store.loadIfNeeded()
        let state = try XCTUnwrap(store.states.first)
        store.select(state)

        let first = try XCTUnwrap(store.currentCard)
        store.nextCard()
        XCTAssertTrue(store.canGoBack)

        XCTAssertTrue(store.previousCard())
        XCTAssertEqual(store.currentCard?.id, first.id)
        XCTAssertFalse(store.canGoBack)
    }

    func testShowCardByIDSwitchesState() throws {
        let store = makeStore()
        store.loadIfNeeded()
        let firstState = try XCTUnwrap(store.states.first)
        let lastState = try XCTUnwrap(store.states.last)
        store.select(firstState)

        let repository = ContentRepository(bundle: Bundle(for: CardRotationTests.self), resourceName: "content")
        let targetCard = try XCTUnwrap(repository.cards(for: lastState).first)

        store.show(cardID: targetCard.id)

        XCTAssertEqual(store.currentCard?.id, targetCard.id)
        XCTAssertEqual(store.currentState?.id, lastState.id)
    }
}
