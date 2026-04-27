import XCTest
@testable import CatBreakCore

final class BreakSettingsTests: XCTestCase {
    func testDefaultsMatchMVPRequirements() {
        let settings = BreakSettings.defaults

        XCTAssertEqual(settings.workInterval, 60 * 60)
        XCTAssertEqual(settings.breakDuration, 5 * 60)
        XCTAssertEqual(settings.timingMode, .activeUse)
        XCTAssertEqual(settings.idlePauseThreshold, 2 * 60)
        XCTAssertEqual(settings.snoozeDuration, 2 * 60)
        XCTAssertEqual(settings.snoozeLimit, 1)
    }
}
