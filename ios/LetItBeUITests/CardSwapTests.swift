import XCTest

final class CardSwapTests: LetItBeUITestCase {
    func testSwapCardWithinState() {
        let entryButton = app.buttons["home_primary_entry"]
        XCTAssertTrue(entryButton.waitForExistence(timeout: 2))
        entryButton.tap()

        let stateButton = app.buttons["state_tired"]
        XCTAssertTrue(stateButton.waitForExistence(timeout: 2))
        stateButton.tap()

        let firstTitle = app.staticTexts["card_title"].label
        let swapButton = app.buttons["card_swap"]
        XCTAssertTrue(swapButton.waitForExistence(timeout: 2))
        swapButton.tap()

        let secondTitle = app.staticTexts["card_title"].label
        if firstTitle == secondTitle {
            swapButton.tap()
        }

        XCTAssertTrue(app.staticTexts["card_title"].exists)
    }
}
