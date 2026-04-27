import Foundation

public enum TimingMode: String, CaseIterable, Codable, Identifiable, Sendable {
    case activeUse
    case wallClock

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .activeUse:
            "Active use"
        case .wallClock:
            "Wall clock"
        }
    }
}

public struct BreakSettings: Codable, Equatable, Sendable {
    public var workInterval: TimeInterval
    public var breakDuration: TimeInterval
    public var timingMode: TimingMode
    public var idlePauseThreshold: TimeInterval
    public var snoozeDuration: TimeInterval
    public var snoozeLimit: Int

    public init(
        workInterval: TimeInterval,
        breakDuration: TimeInterval,
        timingMode: TimingMode,
        idlePauseThreshold: TimeInterval,
        snoozeDuration: TimeInterval,
        snoozeLimit: Int
    ) {
        self.workInterval = workInterval
        self.breakDuration = breakDuration
        self.timingMode = timingMode
        self.idlePauseThreshold = idlePauseThreshold
        self.snoozeDuration = snoozeDuration
        self.snoozeLimit = snoozeLimit
    }

    public static let defaults = BreakSettings(
        workInterval: 60 * 60,
        breakDuration: 5 * 60,
        timingMode: .activeUse,
        idlePauseThreshold: 2 * 60,
        snoozeDuration: 2 * 60,
        snoozeLimit: 1
    )

    public static let shortTest = BreakSettings(
        workInterval: 15,
        breakDuration: 10,
        timingMode: .activeUse,
        idlePauseThreshold: 2,
        snoozeDuration: 5,
        snoozeLimit: 1
    )
}
