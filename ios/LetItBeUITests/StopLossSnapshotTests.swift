import XCTest

final class StopLossSnapshotTests: LetItBeUITestCase {
    func testStopLossUIPlaceholder() {
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
    }
}
