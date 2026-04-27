# Architecture

Keep this short. For a tiny project, this file should answer:

- What are the main parts?
- Where does state live?
- What external systems does this touch?
- What decisions should future agents preserve?

## Likely MVP Shape

- Native macOS menu bar app.
- Local settings for work interval, break duration, snooze duration, snooze limit, timing mode, idle threshold, enforcement mode, and cat overlay style.
- Timer engine schedules break windows using active-use timing by default.
- Full-screen transparent overlay window appears above normal apps on the main display during the first prototype.
- Cat renderer starts with a placeholder bundled asset, then later supports transparent or chroma-keyed video.
- Break controls show countdown, one default snooze, and maybe an emergency quit path.
- Settings or menu bar popover shows time remaining and includes a manual `Cat Now` action for testing.

## State

- Keep state local only.
- Use simple app preferences first.
- No account, network backend, telemetry, or cloud sync unless explicitly added later.

## macOS Surfaces To Validate

- `NSPanel` or borderless `NSWindow` for always-on-top overlay behavior.
- `CGEventSource.secondsSinceLastEventType` or equivalent macOS API for recent keyboard/mouse activity.
- Multiple displays.
- Spaces/full-screen apps.
- Accessibility permissions only if activity-aware app/site detection is chosen.
- Launch-at-login helper if the app should start automatically.

## Decisions To Preserve

- Prefer playful interruption over punitive lockout.
- Prefer minimal permissions for MVP.
- Build the MVP as a whole-system timer, not an app/site-aware blocker.
- Default to active-use timing, with a setting to switch to wall-clock timing.
- Default to one snooze per break, with configurable snooze behavior.
- Target the main display only for the first prototype.
- Use placeholder cat media for the first prototype.
- Keep overlay triggering testable independently from timer scheduling.
- Treat cat media licensing as a product requirement, not a late cleanup task.
