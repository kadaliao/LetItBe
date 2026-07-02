import SwiftUI

/// 首次启动的状态选择仪式；之后启动直达卡片。
struct FirstRunView: View {
    @Environment(ContentStore.self) private var content
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: Theme.spacingMedium) {
            Spacer()

            Circle()
                .strokeBorder(Theme.textColor(scheme), lineWidth: 2)
                .frame(width: 72, height: 72)
                .overlay(
                    Text("home_logo")
                        .font(Theme.fontTitle)
                        .foregroundColor(Theme.textColor(scheme))
                )
                .padding(.bottom, Theme.spacingSmall)

            Text("home_title")
                .font(Theme.fontTitle)
                .tracking(8)
                .foregroundColor(Theme.textColor(scheme))

            Text("home_subtitle")
                .font(Theme.fontSubtitle)
                .textCase(.uppercase)
                .tracking(4)
                .foregroundColor(Theme.secondaryTextColor(scheme))

            Text("picker_title")
                .font(Theme.fontBody)
                .foregroundColor(Theme.secondaryTextColor(scheme))
                .padding(.top, Theme.spacingLarge)

            if let errorMessage = content.errorMessage {
                Text(errorMessage)
                    .font(Theme.fontCaption)
                    .foregroundColor(Theme.secondaryTextColor(scheme))
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.spacingMedium) {
                ForEach(content.states) { state in
                    stateCard(state)
                }
            }
            .padding(.top, Theme.spacingSmall)

            Text("picker_hint")
                .font(Theme.fontCaption)
                .tracking(3)
                .foregroundColor(Theme.secondaryTextColor(scheme))
                .padding(.top, Theme.spacingMedium)

            Spacer()
        }
        .padding(Theme.spacingLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor(scheme))
        .onAppear {
            content.loadIfNeeded()
        }
    }

    private func stateCard(_ state: MoodState) -> some View {
        Button {
            Haptics.selection()
            withAnimation(.easeInOut(duration: Theme.transitionDuration)) {
                content.select(state)
            }
        } label: {
            VStack(spacing: Theme.spacingSmall) {
                StateIconView(style: state.key.iconStyle, isSelected: false)
                    .frame(height: 84)

                Text(state.name)
                    .font(Theme.fontBody)
                    .tracking(4)
                    .foregroundColor(Theme.textColor(scheme))

                Text(state.description ?? "")
                    .font(Theme.fontCaption)
                    .foregroundColor(Theme.secondaryTextColor(scheme))
            }
            .padding(.vertical, Theme.spacingSmall)
            .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier("state_\(state.key.rawValue)")
        .accessibilityLabel(String(format: String(localized: "picker_state_accessibility"), state.name))
    }
}
