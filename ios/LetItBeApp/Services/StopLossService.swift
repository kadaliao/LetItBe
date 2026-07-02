import Foundation

final class StopLossService {
    private let repository: StopLossRepositoryType

    init(repository: StopLossRepositoryType) {
        self.repository = repository
    }

    func startSession(card: Card, state: MoodState, durationSeconds: Int = 120) throws -> StopLossSession {
        return try repository.startSession(
            cardId: card.id,
            stateId: state.id,
            durationSeconds: durationSeconds,
            startedAt: Date()
        )
    }

    func finishSession(_ session: StopLossSession, reason: StopLossExitReason) throws -> StopLossSession {
        let endedAt = Date()
        try repository.finishSession(sessionId: session.id, exitReason: reason, endedAt: endedAt)
        return StopLossSession(
            id: session.id,
            cardId: session.cardId,
            stateId: session.stateId,
            durationSeconds: session.durationSeconds,
            startedAt: session.startedAt,
            endedAt: endedAt,
            exitReason: reason
        )
    }
}
