import SwiftUI

struct StopLossView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: StopLossViewModel

    init(viewModel: StopLossViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: StopLossView.makeDefaultViewModel())
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("呼吸")
                .font(.title2)

            Text(timeString(from: viewModel.remainingSeconds))
                .font(.system(size: 48, weight: .light, design: .rounded))
                .accessibilityIdentifier("stoploss_timer")

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.secondary)
            }

            Button(viewModel.isRunning ? "正在进行..." : "开始") {
                startIfNeeded()
            }
            .disabled(viewModel.isRunning)
            .accessibilityIdentifier("stoploss_start")
            .accessibilityLabel("开始止损计时")

            Button("结束") {
                stopAndReturn()
            }
            .accessibilityIdentifier("stoploss_exit")
            .accessibilityLabel("结束止损并返回主页")
        }
        .padding()
        .onAppear {
            startIfNeeded()
        }
        .onChange(of: viewModel.didComplete) { didComplete in
            if didComplete {
                appState.goHome()
            }
        }
    }

    private func startIfNeeded() {
        guard !viewModel.isRunning else { return }
        guard let card = appState.currentCard, let state = appState.selectedState else {
            appState.goHome()
            return
        }
        viewModel.start(card: card, state: state)
    }

    private func stopAndReturn() {
        viewModel.stop(reason: .canceled)
        appState.goHome()
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return String(format: "%02d:%02d", minutes, remaining)
    }
}

private extension StopLossView {
    static func makeDefaultViewModel() -> StopLossViewModel {
        do {
            let store = try SQLiteStore(databaseName: "letitbe")
            let repository = try StopLossRepository(store: store)
            let service = StopLossService(repository: repository)
            return StopLossViewModel(service: service)
        } catch {
            let repository = InMemoryStopLossRepository()
            let service = StopLossService(repository: repository)
            return StopLossViewModel(service: service)
        }
    }
}
