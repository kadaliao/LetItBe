import Foundation
import SQLite3

protocol StopLossRepositoryType {
    func startSession(cardId: String, stateId: String, durationSeconds: Int, startedAt: Date) throws -> StopLossSession
    func finishSession(sessionId: String, exitReason: StopLossExitReason, endedAt: Date) throws
}

final class StopLossRepository: StopLossRepositoryType {
    private let store: SQLiteStore

    init(store: SQLiteStore) throws {
        self.store = store
        try createTableIfNeeded()
    }

    func startSession(cardId: String, stateId: String, durationSeconds: Int, startedAt: Date) throws -> StopLossSession {
        let sessionId = UUID().uuidString
        let sql = """
        INSERT INTO stop_loss_sessions
        (id, card_id, state_id, duration_seconds, started_at, ended_at, exit_reason)
        VALUES (?, ?, ?, ?, ?, NULL, NULL);
        """
        let statement = try store.prepare(sql)
        defer { store.finalize(statement) }
        sqlite3_bind_text(statement, 1, sessionId, -1, nil)
        sqlite3_bind_text(statement, 2, cardId, -1, nil)
        sqlite3_bind_text(statement, 3, stateId, -1, nil)
        sqlite3_bind_int(statement, 4, Int32(durationSeconds))
        sqlite3_bind_double(statement, 5, startedAt.timeIntervalSince1970)
        _ = try store.step(statement)

        return StopLossSession(
            id: sessionId,
            cardId: cardId,
            stateId: stateId,
            durationSeconds: durationSeconds,
            startedAt: startedAt,
            endedAt: nil,
            exitReason: nil
        )
    }

    func finishSession(sessionId: String, exitReason: StopLossExitReason, endedAt: Date) throws {
        let sql = """
        UPDATE stop_loss_sessions
        SET ended_at = ?, exit_reason = ?
        WHERE id = ?;
        """
        let statement = try store.prepare(sql)
        defer { store.finalize(statement) }
        sqlite3_bind_double(statement, 1, endedAt.timeIntervalSince1970)
        sqlite3_bind_text(statement, 2, exitReason.rawValue, -1, nil)
        sqlite3_bind_text(statement, 3, sessionId, -1, nil)
        _ = try store.step(statement)
    }

    private func createTableIfNeeded() throws {
        let sql = """
        CREATE TABLE IF NOT EXISTS stop_loss_sessions (
            id TEXT PRIMARY KEY,
            card_id TEXT NOT NULL,
            state_id TEXT NOT NULL,
            duration_seconds INTEGER NOT NULL,
            started_at REAL NOT NULL,
            ended_at REAL,
            exit_reason TEXT
        );
        """
        try store.execute(sql)
    }
}

final class InMemoryStopLossRepository: StopLossRepositoryType {
    private var sessions: [String: StopLossSession] = [:]

    func startSession(cardId: String, stateId: String, durationSeconds: Int, startedAt: Date) throws -> StopLossSession {
        let sessionId = UUID().uuidString
        let session = StopLossSession(
            id: sessionId,
            cardId: cardId,
            stateId: stateId,
            durationSeconds: durationSeconds,
            startedAt: startedAt,
            endedAt: nil,
            exitReason: nil
        )
        sessions[sessionId] = session
        return session
    }

    func finishSession(sessionId: String, exitReason: StopLossExitReason, endedAt: Date) throws {
        guard let session = sessions[sessionId] else { return }
        sessions[sessionId] = StopLossSession(
            id: session.id,
            cardId: session.cardId,
            stateId: session.stateId,
            durationSeconds: session.durationSeconds,
            startedAt: session.startedAt,
            endedAt: endedAt,
            exitReason: exitReason
        )
    }
}
