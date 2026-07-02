import SwiftUI

/// 「捡回来」：收藏过的句子。
struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ContentStore.self) private var content
    @Environment(FavoritesStore.self) private var favorites
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            Group {
                if cards.isEmpty {
                    VStack(spacing: Theme.spacingSmall) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(Theme.secondaryTextColor(scheme).opacity(0.6))

                        Text("favorites_empty")
                            .font(Theme.fontCaption)
                            .foregroundColor(Theme.secondaryTextColor(scheme))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(cards) { card in
                            Button {
                                content.show(cardID: card.id)
                                dismiss()
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(card.title)
                                        .font(Theme.fontBody)
                                        .foregroundColor(Theme.textColor(scheme))

                                    Text(card.body.replacingOccurrences(of: "\n", with: " "))
                                        .font(Theme.fontCaption)
                                        .foregroundColor(Theme.secondaryTextColor(scheme))
                                        .lineLimit(1)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Theme.backgroundColor(scheme))
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                favorites.remove(cards[index].id)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.backgroundColor(scheme))
            .scrollContentBackground(.hidden)
            .navigationTitle(Text("favorites_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("common_done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.textColor(scheme))
                    .accessibilityIdentifier("favorites_done")
                }
            }
        }
    }

    private var cards: [Card] {
        favorites.ids.compactMap { content.card(withID: $0) }
    }
}
