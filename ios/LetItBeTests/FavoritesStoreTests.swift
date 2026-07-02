import XCTest
@testable import LetItBeApp

final class FavoritesStoreTests: XCTestCase {
    private var savedIDs: [String] = []

    override func setUp() {
        super.setUp()
        savedIDs = SharedDefaults.favoriteCardIDs
        SharedDefaults.favoriteCardIDs = []
    }

    override func tearDown() {
        SharedDefaults.favoriteCardIDs = savedIDs
        super.tearDown()
    }

    func testToggleAddsAndRemoves() {
        let store = FavoritesStore()
        XCTAssertFalse(store.isFavorite("card_a"))

        store.toggle("card_a")
        XCTAssertTrue(store.isFavorite("card_a"))
        XCTAssertEqual(SharedDefaults.favoriteCardIDs, ["card_a"])

        store.toggle("card_a")
        XCTAssertFalse(store.isFavorite("card_a"))
        XCTAssertEqual(SharedDefaults.favoriteCardIDs, [])
    }

    func testNewestFavoriteComesFirst() {
        let store = FavoritesStore()
        store.toggle("card_a")
        store.toggle("card_b")
        XCTAssertEqual(store.ids, ["card_b", "card_a"])
    }

    func testRemove() {
        let store = FavoritesStore()
        store.toggle("card_a")
        store.toggle("card_b")
        store.remove("card_a")
        XCTAssertEqual(store.ids, ["card_b"])
    }
}
