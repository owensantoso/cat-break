# Timer Semantics

Date: 2026-04-28

## Decision

The MVP should default to counting active computer use rather than raw wall-clock time.

A user is considered active when macOS reports recent keyboard or mouse input. If the user has been idle longer than the configured idle threshold, the work timer pauses until activity resumes.

The app should also include a setting to toggle between active-use timing and wall-clock timing.

## Defaults

- Work interval: 60 minutes of active use.
- Break duration: 5 minutes.
- Idle threshold: 2 minutes.
- Timing mode: active-use timer.

## Rationale

Active-use timing better matches the product promise: interrupt long computer sessions, not time away from the computer. A wall-clock option is useful for people who prefer strict recurring breaks or who find activity detection surprising.

## Later

A hybrid mode can be considered later if active-use timing creates edge cases where breaks are postponed too easily.
