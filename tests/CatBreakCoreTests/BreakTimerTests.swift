import XCTest
@testable import CatBreakCore

final class BreakTimerTests: XCTestCase {
    func testActiveUsePausesWhenIdlePastThreshold() {
        var timer = BreakTimer(settings: BreakSettings(
            workInterval: 10,
            breakDuration: 5,
            timingMode: .activeUse,
            idlePauseThreshold: 2,
            snoozeDuration: 3,
            snoozeLimit: 1
        ))

        XCTAssertNil(timer.tick(elapsed: 8, idleDuration: 3))
        XCTAssertEqual(timer.timeRemainingUntilBreak, 10)
    }

    func testWallClockCountsEvenWhenIdle() {
        var timer = BreakTimer(settings: BreakSettings(
            workInterval: 10,
            breakDuration: 5,
            timingMode: .wallClock,
            idlePauseThreshold: 2,
            snoozeDuration: 3,
            snoozeLimit: 1
        ))

        XCTAssertEqual(timer.tick(elapsed: 10, idleDuration: 100), .breakStarted)
        XCTAssertEqual(timer.phase, .breakActive)
    }

    func testSnoozeIsLimitedAndRetriggersBreakAfterSnoozeDuration() {
        var timer = BreakTimer(settings: BreakSettings(
            workInterval: 10,
            breakDuration: 5,
            timingMode: .wallClock,
            idlePauseThreshold: 2,
            snoozeDuration: 3,
            snoozeLimit: 1
        ))

        timer.startBreak()

        XCTAssertTrue(timer.snooze())
        XCTAssertFalse(timer.snooze())
        XCTAssertEqual(timer.phase, .working)
        XCTAssertEqual(timer.timeRemainingUntilBreak, 3)
        XCTAssertEqual(timer.tick(elapsed: 3, idleDuration: 0), .breakStarted)
        XCTAssertFalse(timer.canSnooze)
    }

    func testBreakFinishesAndResetsWorkAndSnoozeState() {
        var timer = BreakTimer(settings: BreakSettings(
            workInterval: 10,
            breakDuration: 5,
            timingMode: .wallClock,
            idlePauseThreshold: 2,
            snoozeDuration: 3,
            snoozeLimit: 1
        ))

        timer.startBreak()
        XCTAssertTrue(timer.snooze())
        XCTAssertEqual(timer.tick(elapsed: 3, idleDuration: 0), .breakStarted)
        XCTAssertEqual(timer.tick(elapsed: 5, idleDuration: 0), .breakFinished)
        XCTAssertEqual(timer.phase, .working)
        XCTAssertEqual(timer.timeRemainingUntilBreak, 10)
        XCTAssertEqual(timer.snoozesUsed, 0)
    }
}
