import Foundation

public enum BreakPhase: Equatable, Sendable {
    case working
    case breakActive
}

public enum BreakTimerEvent: Equatable, Sendable {
    case breakStarted
    case breakFinished
}

public struct BreakTimer: Equatable, Sendable {
    public private(set) var settings: BreakSettings
    public private(set) var phase: BreakPhase = .working
    public private(set) var accumulatedWork: TimeInterval = 0
    public private(set) var breakRemaining: TimeInterval
    public private(set) var snoozesUsed: Int = 0

    public init(settings: BreakSettings = .defaults) {
        self.settings = settings
        breakRemaining = settings.breakDuration
    }

    public var timeRemainingUntilBreak: TimeInterval {
        max(0, settings.workInterval - accumulatedWork)
    }

    public var canSnooze: Bool {
        phase == .breakActive && snoozesUsed < settings.snoozeLimit
    }

    public mutating func updateSettings(_ newSettings: BreakSettings) {
        settings = newSettings
        accumulatedWork = min(accumulatedWork, newSettings.workInterval)
        breakRemaining = min(max(0, breakRemaining), newSettings.breakDuration)
    }

    public mutating func tick(elapsed: TimeInterval, idleDuration: TimeInterval) -> BreakTimerEvent? {
        let safeElapsed = max(0, elapsed)

        switch phase {
        case .working:
            guard shouldCountWork(idleDuration: idleDuration) else {
                return nil
            }

            accumulatedWork += safeElapsed
            guard accumulatedWork >= settings.workInterval else {
                return nil
            }

            startBreak()
            return .breakStarted

        case .breakActive:
            breakRemaining -= safeElapsed
            guard breakRemaining <= 0 else {
                return nil
            }

            finishBreak()
            return .breakFinished
        }
    }

    public mutating func startBreak() {
        phase = .breakActive
        breakRemaining = settings.breakDuration
    }

    public mutating func finishBreak() {
        phase = .working
        accumulatedWork = 0
        breakRemaining = settings.breakDuration
        snoozesUsed = 0
    }

    public mutating func snooze() -> Bool {
        guard canSnooze else {
            return false
        }

        snoozesUsed += 1
        phase = .working
        breakRemaining = settings.breakDuration
        accumulatedWork = max(0, settings.workInterval - settings.snoozeDuration)
        return true
    }

    private func shouldCountWork(idleDuration: TimeInterval) -> Bool {
        switch settings.timingMode {
        case .activeUse:
            idleDuration <= settings.idlePauseThreshold
        case .wallClock:
            true
        }
    }
}
