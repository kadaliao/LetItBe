import XCTest

final class StatePickerSnapshotTests: LetItBeUITestCase {
    func testStatePickerUIPlaceholder() {
        let entryButton = app.buttons["home_primary_entry"]
        XCTAssertTrue(entryButton.waitForExistence(timeout: 2))
        entryButton.tap()

        XCTAssertTrue(app.buttons["state_tired"].waitForExistence(timeout: 2))
    }
}
