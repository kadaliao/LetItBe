import XCTest
@testable import LetItBeApp

final class StopLossServiceTests: XCTestCase {
    func testStartAndFinishSession() throws {
        let store = try SQLiteStore(databaseName: "test_stoploss_\(UUID().uuidString)")
        let repository = try StopLossRepository(store: store)
        let service = StopLossService(repository: repository)

        let state = State(id: "state_tired", key: .tired, name: "累", description: nil)
        let card = Card(
            id: "card_tired_001",
            stateId: state.id,
            title: "允许断电",
            body: "内容",
            footer: "底部",
            tags: nil,
            actionType: .stopLoss,
            isFavorited: nil
        )

        let session = try service.startSession(card: card, state: state, durationSeconds: 120)
        XCTAssertEqual(session.cardId, card.id)
        XCTAssertEqual(session.stateId, state.id)
        XCTAssertEqual(session.durationSeconds, 120)
        XCTAssertNil(session.endedAt)

        let finished = try service.finishSession(session, reason: .completed)
        XCTAssertNotNil(finished.endedAt)
        XCTAssertEqual(finished.exitReason, .completed)
    }
}
