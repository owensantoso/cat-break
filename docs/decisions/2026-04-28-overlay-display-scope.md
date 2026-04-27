# Overlay Display Scope

Date: 2026-04-28

## Decision

The first prototype should show the cat overlay on the main display only.

All-display support is deferred until after the timer, overlay, controls, and cat rendering loop work reliably on one screen.

## Rationale

Main-display-only keeps the first prototype small and avoids early complexity around multiple displays, Spaces, fullscreen apps, and per-screen overlay windows.

## Later

Before MVP release, evaluate whether all-display support is required. If it is, add one overlay window per active screen and test display attach/detach behavior.
