# Testability Controls

Date: 2026-04-28

## Decision

The app should include built-in controls that make the break overlay and timer easy to test without waiting for the normal work interval.

## Required Controls

- Show time remaining until the next cat break in settings or the menu bar popover.
- Provide a manual `Cat Now` action that immediately shows the break overlay.
- Allow very short work intervals for testing.
- Allow timer behavior and overlay behavior to be tested independently.

## Rationale

The overlay and timer have different failure modes. A manual trigger proves the cat overlay, window level, controls, and dismissal/snooze behavior. Short intervals and visible countdown prove the scheduling logic. Keeping these seams visible reduces debugging time and makes the app easier to trust while developing.

## Product Stance

These controls can be normal settings rather than debug-only features, as long as the defaults remain sensible. If the interface becomes cluttered, move advanced testing controls behind an advanced/debug section later.
