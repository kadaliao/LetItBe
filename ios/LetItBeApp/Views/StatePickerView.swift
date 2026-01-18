import SwiftUI

struct StatePickerView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: StatePickerViewModel

    init(viewModel: StatePickerViewModel = StatePickerViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("现在感觉如何？")
                .font(.title2)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.secondary)
            }

            ForEach(viewModel.states) { state in
                Button(state.name) {
                    if let card = viewModel.randomCard(for: state) {
                        appState.goToCard(card, state: state)
                    } else {
                        appState.goHome()
                    }
                }
                .accessibilityIdentifier("state_\(state.key.rawValue)")
                .accessibilityLabel("选择状态：\(state.name)")
            }
        }
        .padding()
        .onAppear {
            viewModel.loadStates()
        }
    }
}
