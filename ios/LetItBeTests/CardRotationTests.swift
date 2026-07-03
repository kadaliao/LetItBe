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

    func testPeekNextMatchesNextCard() throws {
        let store = makeStore()
        store.loadIfNeeded()
        let state = try XCTUnwrap(store.states.first)
        store.select(state)

        for _ in 0..<5 {
            let peeked = try XCTUnwrap(store.peekNextCard())
            store.nextCard()
            XCTAssertEqual(store.currentCard?.id, peeked.id, "预览的底牌必须与实际抽到的下一张一致")
        }
    }

    func testPeekPreviousMatchesHistory() throws {
        let store = makeStore()
        store.loadIfNeeded()
        let state = try XCTUnwrap(store.states.first)
        store.select(state)

        XCTAssertNil(store.peekPreviousCard())
        let first = try XCTUnwrap(store.currentCard)
        store.nextCard()
        XCTAssertEqual(store.peekPreviousCard()?.id, first.id)
    }

    /// Widget 深链的两种启动时序都必须落在目标卡上。
    func testDeepLinkSurvivesRestoreOrdering() throws {
        let bundle = Bundle(for: CardRotationTests.self)
        let repository = ContentRepository(bundle: bundle, resourceName: "content")
        let anyState = try XCTUnwrap(try repository.states().last)
        let target = try XCTUnwrap(try repository.cards(for: anyState).first)
        SharedDefaults.lastState = anyState.key
        defer { SharedDefaults.lastState = nil }

        // 时序 A：先恢复上次会话，再收到深链
        let storeA = makeStore()
        storeA.restoreLastSession()
        storeA.show(cardID: target.id)
        XCTAssertEqual(storeA.currentCard?.id, target.id)

        // 时序 B：先收到深链，再跑恢复逻辑（不得覆盖深链卡片）
        let storeB = makeStore()
        storeB.show(cardID: target.id)
        storeB.restoreLastSession()
        XCTAssertEqual(storeB.currentCard?.id, target.id)
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
