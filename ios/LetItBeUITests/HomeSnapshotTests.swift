import XCTest

final class HomeSnapshotTests: LetItBeUITestCase {
    func testHomeUIPlaceholder() {
        XCTAssertTrue(app.buttons["home_primary_entry"].waitForExistence(timeout: 2))
    }
}
