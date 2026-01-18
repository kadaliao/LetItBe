import Foundation

@MainActor
final class StopLossViewModel: ObservableObject {
    @Published private(set) var remainingSeconds: Int = 120
    @Published private(set) var isRunning = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var didComplete = false

    private let service: StopLossService
    private var timer: Timer?
    private(set) var session: StopLossSession?

    init(service: StopLossService) {
        self.service = service
    }

    func start(card: Card, state: State, durationSeconds: Int = 120) {
        do {
            session = try service.startSession(card: card, state: state, durationSeconds: durationSeconds)
            remainingSeconds = durationSeconds
            isRunning = true
            errorMessage = nil
            didComplete = false
            startTimer()
        } catch {
            errorMessage = "无法开始止损"
        }
    }

    func stop(reason: StopLossExitReason) {
        guard let session else { return }
        timer?.invalidate()
        timer = nil
        isRunning = false
        do {
            _ = try service.finishSession(session, reason: reason)
            if reason == .completed {
                didComplete = true
            }
        } catch {
            errorMessage = "无法结束止损"
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                    if self.remainingSeconds == 0 {
                        self.stop(reason: .completed)
                    }
                }
            }
        }
    }
}
