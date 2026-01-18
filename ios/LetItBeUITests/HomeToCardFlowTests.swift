import XCTest

final class HomeToCardFlowTests: XCTestCase {
    func testHomeToCardFlow() {
        let app = XCUIApplication()
        app.launch()

        let entryButton = app.buttons["home_primary_entry"]
        XCTAssertTrue(entryButton.waitForExistence(timeout: 2))
        entryButton.tap()

        let stateButton = app.buttons["state_tired"]
        XCTAssertTrue(stateButton.waitForExistence(timeout: 2))
        stateButton.tap()

        XCTAssertTrue(app.staticTexts["card_title"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["card_body"].exists)
        XCTAssertTrue(app.staticTexts["card_footer"].exists)
    }
}
