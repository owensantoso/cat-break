import Foundation

public enum DurationFormatting {
    public static func minutesAndSeconds(_ duration: TimeInterval) -> String {
        let totalSeconds = max(0, Int(duration.rounded(.up)))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
}
