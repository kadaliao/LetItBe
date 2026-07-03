import XCTest

final class RepairFlowTests: LetItBeUITestCase {
    func testBreathingFlow() {
        launch(state: "tired")

        let repairButton = app.buttons["stop_loss_entry"]
        XCTAssertTrue(repairButton.waitForExistence(timeout: 3))
        repairButton.tap()

        XCTAssertTrue(app.buttons["duration_120"].waitForExistence(timeout: 3))

        let startButton = app.buttons["stoploss_start"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()

        XCTAssertTrue(app.staticTexts["stoploss_timer"].waitForExistence(timeout: 3))

        let exitButton = app.buttons["stoploss_exit"]
        XCTAssertTrue(exitButton.waitForExistence(timeout: 2))
        exitButton.tap()

        XCTAssertTrue(app.buttons["stop_loss_entry"].waitForExistence(timeout: 3))
    }

    func testThrowawayFlow() {
        launch(state: "annoyed")

        let repairButton = app.buttons["stop_loss_entry"]
        XCTAssertTrue(repairButton.waitForExistence(timeout: 3))
        repairButton.tap()

        let throwawayTab = app.buttons["repair_tab_throwaway"]
        XCTAssertTrue(throwawayTab.waitForExistence(timeout: 3))
        throwawayTab.tap()

        let field = app.textFields["throwaway_field"]
        XCTAssertTrue(field.waitForExistence(timeout: 2))
        field.tap()
        field.typeText("test noise")

        let throwButton = app.buttons["throwaway_action"]
        XCTAssertTrue(throwButton.waitForExistence(timeout: 2))
        throwButton.tap()

        // 纸团飞走后出现收尾句
        XCTAssertTrue(app.staticTexts["throwaway_done"].waitForExistence(timeout: 4))

        let exitButton = app.buttons["stoploss_exit"]
        XCTAssertTrue(exitButton.waitForExistence(timeout: 2))
        exitButton.tap()

        XCTAssertTrue(app.buttons["stop_loss_entry"].waitForExistence(timeout: 3))
    }

    func testChecklistFlow() {
        launch(state: "tired")

        let repairButton = app.buttons["stop_loss_entry"]
        XCTAssertTrue(repairButton.waitForExistence(timeout: 3))
        repairButton.tap()

        let checklistTab = app.buttons["repair_tab_checklist"]
        XCTAssertTrue(checklistTab.waitForExistence(timeout: 3))
        checklistTab.tap()

        let waterItem = app.buttons["checklist_checklist_water"]
        XCTAssertTrue(waterItem.waitForExistence(timeout: 2))
        waterItem.tap()

        let exitButton = app.buttons["stoploss_exit"]
        XCTAssertTrue(exitButton.waitForExistence(timeout: 2))
        exitButton.tap()

        XCTAssertTrue(app.buttons["stop_loss_entry"].waitForExistence(timeout: 3))
    }
}
