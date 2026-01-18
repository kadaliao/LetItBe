import XCTest

final class StopLossFlowTests: XCTestCase {
    func testStopLossFlow() {
        let app = XCUIApplication()
        app.launch()

        let entryButton = app.buttons["home_primary_entry"]
        XCTAssertTrue(entryButton.waitForExistence(timeout: 2))
        entryButton.tap()

        let stateButton = app.buttons["state_tired"]
        XCTAssertTrue(stateButton.waitForExistence(timeout: 2))
        stateButton.tap()

        let stopLossButton = app.buttons["stop_loss_entry"]
        XCTAssertTrue(stopLossButton.waitForExistence(timeout: 2))
        stopLossButton.tap()

        XCTAssertTrue(app.staticTexts["stoploss_timer"].waitForExistence(timeout: 2))

        let exitButton = app.buttons["stoploss_exit"]
        XCTAssertTrue(exitButton.waitForExistence(timeout: 2))
        exitButton.tap()

        XCTAssertTrue(entryButton.waitForExistence(timeout: 2))
    }
}
