import CoreGraphics
import Foundation

enum SystemIdleMonitor {
    static var secondsSinceLastInput: TimeInterval {
        let eventTypes: [CGEventType] = [
            .keyDown,
            .flagsChanged,
            .mouseMoved,
            .leftMouseDown,
            .leftMouseDragged,
            .rightMouseDown,
            .rightMouseDragged,
            .otherMouseDown,
            .otherMouseDragged,
            .scrollWheel
        ]

        return eventTypes
            .map { CGEventSource.secondsSinceLastEventType(.combinedSessionState, eventType: $0) }
            .min() ?? 0
    }
}
