# Cat Break

Native macOS break app concept: every configurable interval, a large cat overlay interrupts the computer session and nudges the user to get up.

## Current Status

This repo has an initial native macOS Swift Package prototype.

Start here:

1. [Current state](docs/CURRENT_STATE.md)
2. [MVP spec](docs/product/specs/SPEC-0001-cat-break-mvp.md)
3. [Native macOS prototype plan](docs/product/plans/PLAN-0001-native-macos-prototype/PLAN-0001-native-macos-prototype.md)
4. [First implementation brief](docs/product/plans/PLAN-0001-native-macos-prototype/IMPL-0001-01-scaffold-native-macos-prototype.md)

## MVP Shape

- Whole-system macOS break timer.
- Default: 60 minutes of active computer use.
- Default break: 5 minutes.
- One 2-minute snooze per break by default.
- Main-display overlay first.
- Placeholder cat asset first.
- Visible time remaining and `Cat Now` test action.

## Run Prototype

```bash
swift run CatBreak
```

The first prototype opens a small controller window. Use `Cat Now` to show the placeholder cat overlay, or `Short Test Settings` to verify timer behavior quickly.

## Docs

This repo uses AGENT-DOCS-style numbered source docs and generated views. Use `scripts/docs-meta` for IDs, registries, and checks.
