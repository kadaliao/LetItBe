import Foundation

struct StopLossSession: Identifiable, Equatable {
    let id: String
    let cardId: String
    let stateId: String
    let durationSeconds: Int
    let startedAt: Date
    let endedAt: Date?
    let exitReason: StopLossExitReason?
}

enum StopLossExitReason: String {
    case completed
    case canceled
}
