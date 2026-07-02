import Foundation
import ActivityKit

@Observable
@MainActor
final class StopLossViewModel {
    enum Phase {
        case idle
        case running
        case finished
    }

    private(set) var phase: Phase = .idle
    private(set) var remainingSeconds: Int = 120
    private(set) var isInhaling = true
    private(set) var errorMessage: String?
    var selectedDuration: Int = 120 {
        didSet {
            // 未开始时，倒计时显示跟随所选时长
            if phase == .idle {
                remainingSeconds = selectedDuration
            }
        }
    }

    private let service: StopLossService
    private var timer: Timer?
    private let breathCycleSeconds = 4
    private var sessionDurationSeconds = 120
    private(set) var session: StopLossSession?
    private var liveActivity: Activity<BreathingActivityAttributes>?

    init(service: StopLossService) {
        self.service = service
    }

    func start(card: Card, state: MoodState) {
        let duration = selectedDuration
        do {
            session = try service.startSession(card: card, state: state, durationSeconds: duration)
            remainingSeconds = duration
            sessionDurationSeconds = duration
            phase = .running
            isInhaling = true
            errorMessage = nil
            startTimer()
            startLiveActivity(durationSeconds: duration)
        } catch {
            errorMessage = String(localized: "error_start_repair")
        }
    }

    func cancelIfRunning() {
        guard phase == .running else { return }
        stop(reason: .canceled)
    }

    /// 清单模式：记录一次完成的极简动作（无计时）。
    func recordChecklist(card: Card, state: MoodState) {
        guard let session = try? service.startSession(card: card, state: state, durationSeconds: 0) else { return }
        _ = try? service.finishSession(session, reason: .completed)
    }

    private func stop(reason: StopLossExitReason) {
        guard let session else { return }
        timer?.invalidate()
        timer = nil
        isInhaling = true
        endLiveActivity()
        do {
            _ = try service.finishSession(session, reason: reason)
            phase = reason == .completed ? .finished : .idle
        } catch {
            phase = .idle
            errorMessage = String(localized: "error_end_repair")
        }
        self.session = nil
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.phase == .running, self.remainingSeconds > 0 else { return }
                self.remainingSeconds -= 1
                self.updateBreathPhase()
                if self.remainingSeconds == 0 {
                    self.stop(reason: .completed)
                }
            }
        }
    }

    private func updateBreathPhase() {
        let elapsedSeconds = sessionDurationSeconds - remainingSeconds
        isInhaling = (elapsedSeconds / breathCycleSeconds) % 2 == 0
    }

    // MARK: - Live Activity

    private func startLiveActivity(durationSeconds: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let endDate = Date().addingTimeInterval(TimeInterval(durationSeconds))
        let content = ActivityContent(
            state: BreathingActivityAttributes.ContentState(endDate: endDate),
            staleDate: endDate
        )
        liveActivity = try? Activity.request(
            attributes: BreathingActivityAttributes(startDate: Date()),
            content: content
        )
    }

    private func endLiveActivity() {
        guard let liveActivity else { return }
        self.liveActivity = nil
        Task {
            await liveActivity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
