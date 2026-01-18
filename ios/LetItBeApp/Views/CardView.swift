import SwiftUI

struct CardView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: CardViewModel

    init(viewModel: CardViewModel = CardViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            if let card = viewModel.card {
                Text(card.title)
                    .font(.title2)
                    .accessibilityIdentifier("card_title")

                Text(card.body)
                    .accessibilityIdentifier("card_body")

                Text(card.footer)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("card_footer")

                HStack(spacing: 12) {
                    Button("止损一下") {
                        appState.goToStopLoss()
                    }
                    .accessibilityIdentifier("stop_loss_entry")
                    .accessibilityLabel("进入止损计时")
                    Button("换一条") {
                        if let state = appState.selectedState {
                            viewModel.nextCard(state: state)
                        }
                    }
                    .accessibilityIdentifier("card_swap")
                    .accessibilityLabel("切换到另一条卡片")
                }
            } else {
                Text(viewModel.errorMessage ?? "暂无内容")
            }
        }
        .padding()
        .onAppear {
            if let state = appState.selectedState {
                viewModel.loadInitialCard(state: state)
            }
        }
    }
}
