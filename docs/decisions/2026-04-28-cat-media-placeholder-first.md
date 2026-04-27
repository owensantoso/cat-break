# Cat Media Placeholder First

Date: 2026-04-28

## Decision

The first prototype should use a placeholder bundled cat asset instead of implementing the real green-screen/chroma-key video pipeline immediately.

The production cat media pipeline is deferred until the timer, overlay, snooze controls, and main-display behavior are proven.

## Rationale

The first technical risks are macOS overlay behavior and break timing. A placeholder asset keeps the prototype focused and prevents media licensing, transparency, and chroma-key rendering issues from blocking the core app loop.

## Later

Evaluate licensed media options and rendering approaches:

- Bundled transparent video.
- Bundled green-screen video with chroma key.
- User-provided custom cat media.
- Multiple cat presets.
