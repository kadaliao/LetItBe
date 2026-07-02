import Foundation

@Observable
final class FavoritesStore {
    private(set) var ids: [String]

    init() {
        ids = SharedDefaults.favoriteCardIDs
    }

    func isFavorite(_ cardID: String) -> Bool {
        ids.contains(cardID)
    }

    func toggle(_ cardID: String) {
        if let index = ids.firstIndex(of: cardID) {
            ids.remove(at: index)
        } else {
            ids.insert(cardID, at: 0)
        }
        SharedDefaults.favoriteCardIDs = ids
    }

    func remove(_ cardID: String) {
        ids.removeAll { $0 == cardID }
        SharedDefaults.favoriteCardIDs = ids
    }
}
