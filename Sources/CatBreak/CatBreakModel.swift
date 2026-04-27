import CatBreakCore
import Foundation
import Observation

@MainActor
@Observable
final class CatBreakModel {
    var settings: BreakSettings {
        didSet {
            timer.updateSettings(settings)
            Diagnostics.settingsChanged(settings.diagnosticSnapshot)
        }
    }

    private(set) var timer: BreakTimer
    private(set) var lastIdleDuration: TimeInterval = 0
    private(set) var idlePaused = false

    @ObservationIgnored private var tickTimer: Timer?
    @ObservationIgnored private var previousTick: Date?
    @ObservationIgnored var onBreakStarted: (() -> Void)?
    @ObservationIgnored var onBreakEnded: (() -> Void)?

    init(settings: BreakSettings = .defaults) {
        self.settings = settings
        timer = BreakTimer(settings: settings)
    }

    var phaseTitle: String {
        switch timer.phase {
        case .working:
            idlePaused ? "Paused while idle" : "Counting down"
        case .breakActive:
            "Cat break"
        }
    }

    var timeRemainingText: String {
        DurationFormatting.minutesAndSeconds(timer.timeRemainingUntilBreak)
    }

    var displayedCountdownText: String {
        switch timer.phase {
        case .working:
            timeRemainingText
        case .breakActive:
            breakRemainingText
        }
    }

    var breakRemainingText: String {
        DurationFormatting.minutesAndSeconds(timer.breakRemaining)
    }

    var snoozeStatusText: String {
        "\(timer.snoozesUsed) of \(settings.snoozeLimit) snoozes used"
    }

    var canSnooze: Bool {
        timer.canSnooze
    }

    func tick(now: Date, previousTick: inout Date?, idleDuration: TimeInterval) {
        let elapsed = previousTick.map { now.timeIntervalSince($0) } ?? 0
        previousTick = now
        lastIdleDuration = idleDuration
        idlePaused = settings.timingMode == .activeUse && idleDuration > settings.idlePauseThreshold

        switch timer.tick(elapsed: elapsed, idleDuration: idleDuration) {
        case .breakStarted:
            Diagnostics.breakStarted(
                trigger: "timer",
                workRemaining: timer.timeRemainingUntilBreak,
                breakDuration: settings.breakDuration
            )
            onBreakStarted?()
        case .breakFinished:
            Diagnostics.breakFinished()
            onBreakEnded?()
        case nil:
            break
        }
    }

    func startTicking() {
        guard tickTimer == nil else {
            return
        }

        previousTick = nil
        let scheduledTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else {
                    return
                }

                self.tick(now: Date(), previousTick: &self.previousTick, idleDuration: SystemIdleMonitor.secondsSinceLastInput)
            }
        }
        scheduledTimer.tolerance = 0.2
        tickTimer = scheduledTimer
        Diagnostics.tickingStarted()
    }

    func stopTicking() {
        tickTimer?.invalidate()
        tickTimer = nil
        previousTick = nil
    }

    func catNow() {
        timer.startBreak()
        idlePaused = false
        Diagnostics.breakStarted(
            trigger: "cat_now",
            workRemaining: timer.timeRemainingUntilBreak,
            breakDuration: settings.breakDuration
        )
        onBreakStarted?()
    }

    func snoozeBreak() {
        guard timer.snooze() else {
            return
        }

        Diagnostics.breakSnoozed(
            snoozesUsed: timer.snoozesUsed,
            snoozeLimit: settings.snoozeLimit,
            snoozeDuration: settings.snoozeDuration
        )
        onBreakEnded?()
    }

    func finishBreak() {
        timer.finishBreak()
        Diagnostics.breakFinished()
        onBreakEnded?()
    }

    func resetTimer() {
        timer.finishBreak()
        idlePaused = false
        previousTick = nil
        Diagnostics.reset()
        onBreakEnded?()
    }

    func useShortTestSettings() {
        settings = .shortTest
        resetTimer()
    }
}

private extension BreakSettings {
    var diagnosticSnapshot: BreakSettingsSnapshot {
        BreakSettingsSnapshot(
            workInterval: workInterval,
            breakDuration: breakDuration,
            timingMode: timingMode.rawValue,
            idlePauseThreshold: idlePauseThreshold,
            snoozeDuration: snoozeDuration,
            snoozeLimit: snoozeLimit
        )
    }
}
