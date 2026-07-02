import XCTest

final class FavoritesFlowTests: LetItBeUITestCase {
    func testFavoriteAndOpenFavoritesList() {
        launch(state: "tired")

        let favoriteButton = app.buttons["card_favorite"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 3))
        favoriteButton.tap()

        let menuButton = app.buttons["main_menu"]
        XCTAssertTrue(menuButton.waitForExistence(timeout: 2))
        menuButton.tap()

        let favoritesItem = app.buttons["menu_item_favorites"]
        XCTAssertTrue(favoritesItem.waitForExistence(timeout: 2))
        favoritesItem.tap()

        let doneButton = app.buttons["favorites_done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 3))
        doneButton.tap()

        XCTAssertTrue(app.staticTexts["card_title"].waitForExistence(timeout: 3))
    }
}
