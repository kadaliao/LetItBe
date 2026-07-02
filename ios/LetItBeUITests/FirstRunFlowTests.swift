import XCTest

final class FirstRunFlowTests: LetItBeUITestCase {
    func testFirstRunPickerToCard() {
        launchFirstRun()

        let stateButton = app.buttons["state_tired"]
        XCTAssertTrue(stateButton.waitForExistence(timeout: 3))
        stateButton.tap()

        XCTAssertTrue(app.staticTexts["card_title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["card_body"].exists)
        XCTAssertTrue(app.staticTexts["card_footer"].exists)
    }

    func testLaunchWithLastStateGoesStraightToCard() {
        launch(state: "tired")

        XCTAssertTrue(app.staticTexts["card_title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["state_chip_tired"].exists)
        XCTAssertTrue(app.buttons["card_swap"].exists)
    }

    func testStateChipSwitchesState() {
        launch(state: "tired")

        XCTAssertTrue(app.staticTexts["card_title"].waitForExistence(timeout: 3))
        let numbChip = app.buttons["state_chip_numb"]
        XCTAssertTrue(numbChip.waitForExistence(timeout: 2))
        numbChip.tap()

        XCTAssertTrue(app.staticTexts["card_title"].waitForExistence(timeout: 3))
    }
}
