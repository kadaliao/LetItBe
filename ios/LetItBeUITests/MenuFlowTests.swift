import XCTest

final class MenuFlowTests: LetItBeUITestCase {
    func testAboutSheetOpensAndCloses() {
        launch(state: "tired")

        let menuButton = app.buttons["main_menu"]
        XCTAssertTrue(menuButton.waitForExistence(timeout: 3))
        menuButton.tap()

        let aboutItem = app.buttons["menu_item_about"]
        XCTAssertTrue(aboutItem.waitForExistence(timeout: 2))
        aboutItem.tap()

        let doneButton = app.buttons["about_done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 3))
        doneButton.tap()

        XCTAssertTrue(app.staticTexts["card_title"].waitForExistence(timeout: 3))
    }

    func testShareControlVisibleOnCard() {
        launch(state: "tired")

        XCTAssertTrue(app.buttons["card_share"].waitForExistence(timeout: 3))
    }
}
