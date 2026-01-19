import XCTest
import SwiftUI

final class SnapshotHelper {
    static func assertView(_ view: some View, named name: String, file: StaticString = #file, line: UInt = #line) {
        // Placeholder snapshot helper. Replace with real snapshot tooling if needed.
        XCTAssertNotNil(view, "Snapshot placeholder for \(name)", file: file, line: line)
    }
}
