import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 24) {
            Text("摆烂心法")
                .font(.largeTitle)

            Button("我想摆烂") {
                appState.goToPicker()
            }
            .accessibilityIdentifier("home_primary_entry")
            .accessibilityLabel("进入状态选择")
        }
        .padding()
    }
}
