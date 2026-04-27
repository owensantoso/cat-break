# Break Enforcement

Date: 2026-04-28

## Decision

During a break, the cat overlay should be snoozable but not freely dismissible by default.

The default behavior is one snooze per break. Snoozing delays the break briefly, then the break returns. The number of snoozes, snooze duration, and enforcement behavior should be configurable in settings.

## Defaults

- Snooze duration: 2 minutes.
- Snoozes allowed per break: 1.
- Free dismiss: off.

## Rationale

A single snooze gives the user a humane escape hatch when they are in the middle of something, while still preserving the purpose of the app. Making the behavior configurable avoids turning a playful break app into something that feels punitive or malware-like.

## Later

Consider additional modes after the MVP:

- Gentle mode: dismissible with reminder.
- Firm mode: snooze-limited countdown.
- Strict mode: no snooze except emergency quit.
