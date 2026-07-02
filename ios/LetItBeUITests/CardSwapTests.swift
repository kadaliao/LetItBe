import XCTest

final class CardSwapTests: LetItBeUITestCase {
    func testSwapButtonChangesCard() {
        launch(state: "tired")

        let title = app.staticTexts["card_title"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
        let firstTitle = title.label

        let swapButton = app.buttons["card_swap"]
        XCTAssertTrue(swapButton.waitForExistence(timeout: 2))
        swapButton.tap()

        let changed = NSPredicate(format: "label != %@", firstTitle)
        let expectation = XCTNSPredicateExpectation(predicate: changed, object: title)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 3), .completed)
    }

    func testSwipeLeftChangesCard() {
        launch(state: "tired")

        let title = app.staticTexts["card_title"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
        let firstTitle = title.label

        let card = app.staticTexts["card_body"]
        card.swipeLeft()

        let changed = NSPredicate(format: "label != %@", firstTitle)
        let expectation = XCTNSPredicateExpectation(predicate: changed, object: title)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 3), .completed)
    }
}
