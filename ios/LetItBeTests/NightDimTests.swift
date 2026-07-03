import XCTest
@testable import LetItBeApp

final class NightDimTests: XCTestCase {
    func testNightWindowHours() {
        XCTAssertTrue(NightDim.isNight(hour: 22))
        XCTAssertTrue(NightDim.isNight(hour: 23))
        XCTAssertTrue(NightDim.isNight(hour: 0))
        XCTAssertTrue(NightDim.isNight(hour: 4))

        XCTAssertFalse(NightDim.isNight(hour: 5))
        XCTAssertFalse(NightDim.isNight(hour: 9))
        XCTAssertFalse(NightDim.isNight(hour: 14))
        XCTAssertFalse(NightDim.isNight(hour: 21))
    }

    func testNightWindowFromDate() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!

        var components = DateComponents(year: 2026, month: 7, day: 3, hour: 23, minute: 30)
        components.timeZone = calendar.timeZone
        let lateNight = calendar.date(from: components)!
        XCTAssertTrue(NightDim.isNight(lateNight, calendar: calendar))

        components.hour = 10
        let morning = calendar.date(from: components)!
        XCTAssertFalse(NightDim.isNight(morning, calendar: calendar))
    }
}
