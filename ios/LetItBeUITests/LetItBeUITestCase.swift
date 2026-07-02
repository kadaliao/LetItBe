import XCTest

class LetItBeUITestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app.terminate()
        app = nil
        super.tearDown()
    }

    /// 首次启动：无上次状态，进入状态选择仪式。
    func launchFirstRun() {
        app.launchArguments = ["-ui-testing"]
        app.launch()
    }

    /// 预置上次状态：启动直达卡片页。
    func launch(state: String) {
        app.launchArguments = ["-ui-testing", "-ui-testing-state", state]
        app.launch()
    }
}
