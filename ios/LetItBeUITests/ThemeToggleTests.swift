import XCTest

final class ThemeToggleTests: LetItBeUITestCase {
    func testThemeTogglePlaceholder() {
        let entryButton = app.buttons["home_primary_entry"]
        XCTAssertTrue(entryButton.waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["theme_toggle"].waitForExistence(timeout: 2))

        entryButton.tap()

        let stateButton = app.buttons["state_tired"]
        XCTAssertTrue(stateButton.waitForExistence(timeout: 2))
        stateButton.tap()

        let stopLossButton = app.buttons["stop_loss_entry"]
        XCTAssertTrue(stopLossButton.waitForExistence(timeout: 2))
        stopLossButton.tap()

        XCTAssertFalse(app.buttons["theme_toggle"].exists)
    }
}
