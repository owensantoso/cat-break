import Foundation
import OSLog

@MainActor
enum Diagnostics {
    static let diagID = "DIAG-0001"
    static let runID = "run-\(Self.timestampToken())"
    static let logger = Logger(subsystem: "com.owensantoso.CatBreak", category: "PrototypeRuntime")
    private static let processStart = Date()
    private static var sequence = 0

    static func appStarted() {
        logger.info("event=app.started diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public)")
        writeJSONLEvent("app.started")
    }

    static func tickingStarted() {
        logger.info("event=timer.ticking_started diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public)")
        writeJSONLEvent("timer.ticking_started")
    }

    static func settingsChanged(_ settings: BreakSettingsSnapshot) {
        logger.info("event=settings.changed diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public) work_interval_s=\(settings.workInterval, privacy: .public) break_duration_s=\(settings.breakDuration, privacy: .public) timing_mode=\(settings.timingMode, privacy: .public) idle_threshold_s=\(settings.idlePauseThreshold, privacy: .public) snooze_duration_s=\(settings.snoozeDuration, privacy: .public) snooze_limit=\(settings.snoozeLimit, privacy: .public)")
        writeJSONLEvent("settings.changed", attrs: [
            "work_interval_s": settings.workInterval,
            "break_duration_s": settings.breakDuration,
            "timing_mode": settings.timingMode,
            "idle_threshold_s": settings.idlePauseThreshold,
            "snooze_duration_s": settings.snoozeDuration,
            "snooze_limit": settings.snoozeLimit
        ])
    }

    static func breakStarted(trigger: String, workRemaining: TimeInterval, breakDuration: TimeInterval) {
        logger.info("event=break.started diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public) trigger=\(trigger, privacy: .public) work_remaining_s=\(workRemaining, privacy: .public) break_duration_s=\(breakDuration, privacy: .public)")
        writeJSONLEvent("break.started", attrs: [
            "trigger": trigger,
            "work_remaining_s": workRemaining,
            "break_duration_s": breakDuration
        ])
    }

    static func breakFinished() {
        logger.info("event=break.finished diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public)")
        writeJSONLEvent("break.finished")
    }

    static func breakSnoozed(snoozesUsed: Int, snoozeLimit: Int, snoozeDuration: TimeInterval) {
        logger.info("event=break.snoozed diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public) snoozes_used=\(snoozesUsed, privacy: .public) snooze_limit=\(snoozeLimit, privacy: .public) snooze_duration_s=\(snoozeDuration, privacy: .public)")
        writeJSONLEvent("break.snoozed", attrs: [
            "snoozes_used": snoozesUsed,
            "snooze_limit": snoozeLimit,
            "snooze_duration_s": snoozeDuration
        ])
    }

    static func overlayShown(frame: CGRect) {
        logger.info("event=overlay.shown diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public) frame_width=\(frame.width, privacy: .public) frame_height=\(frame.height, privacy: .public)")
        writeJSONLEvent("overlay.shown", attrs: [
            "frame_width": frame.width,
            "frame_height": frame.height
        ])
    }

    static func overlayHidden() {
        logger.info("event=overlay.hidden diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public)")
        writeJSONLEvent("overlay.hidden")
    }

    static func reset() {
        logger.info("event=timer.reset diag_id=\(diagID, privacy: .public) run_id=\(runID, privacy: .public)")
        writeJSONLEvent("timer.reset")
    }

    private static func timestampToken() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        formatter.timeZone = .current
        return formatter.string(from: Date())
    }

    private static func writeJSONLEvent(_ event: String, attrs: [String: Sendable] = [:]) {
        guard let tracePath = ProcessInfo.processInfo.environment["CATBREAK_TRACE_PATH"],
              !tracePath.isEmpty
        else {
            return
        }

        sequence += 1
        let payload: [String: Any] = [
            "schema_version": 1,
            "seq": sequence,
            "ts": ISO8601DateFormatter().string(from: Date()),
            "elapsed_ms": max(0, Date().timeIntervalSince(processStart) * 1_000),
            "monotonic_origin": "process_start",
            "diag_id": diagID,
            "run_id": runID,
            "level": "info",
            "component": "CatBreak",
            "event": event,
            "redaction": [
                "classification": "public-metadata",
                "contains_raw_user_content": false,
                "safe_to_commit": false
            ],
            "attrs": attrs
        ]

        if let data = try? JSONSerialization.data(withJSONObject: payload),
           let line = String(data: data, encoding: .utf8) {
            let url = URL(fileURLWithPath: tracePath)
            try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            append("\(line)\n", to: url)
        }
    }

    private static func append(_ string: String, to url: URL) {
        guard let data = string.data(using: .utf8) else {
            return
        }

        if FileManager.default.fileExists(atPath: url.path),
           let handle = try? FileHandle(forWritingTo: url) {
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        } else {
            try? data.write(to: url)
        }
    }
}

struct BreakSettingsSnapshot {
    let workInterval: TimeInterval
    let breakDuration: TimeInterval
    let timingMode: String
    let idlePauseThreshold: TimeInterval
    let snoozeDuration: TimeInterval
    let snoozeLimit: Int
}
