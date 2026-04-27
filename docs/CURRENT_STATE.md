# Current State

What is true today?

## Built

- AGENT-DOCS `small` scaffold is installed.
- Git repository is initialized locally.
- Public GitHub repository exists at https://github.com/owensantoso/cat-break.
- Initial native macOS Swift Package prototype exists.
- The package builds an executable named `CatBreak`.
- Current prototype includes:
  - Small SwiftUI controller window.
  - Local in-memory settings defaults for work interval, break duration, timing mode, idle pause threshold, snooze duration, and snooze limit.
  - Visible time remaining.
  - `Cat Now` manual trigger.
  - Main-display AppKit overlay with bundled placeholder cat text, countdown, and one-snooze behavior.
  - Basic active-use vs. wall-clock timer logic.
- Product concept: a native macOS break app inspired by Cat Gatekeeper for Chrome.
- MVP scope decision: whole-system break timer first; app/site-aware behavior can come later.
- Timer semantics decision: default to active computer use; include a setting to switch to wall-clock timing.
- Break enforcement decision: snoozable once per break by default; snooze behavior should be configurable.
- Overlay display decision: first prototype targets the main display only.
- Cat media decision: use a placeholder bundled asset for the first prototype.
- Testability decision: include visible time remaining, short test intervals, and a manual `Cat Now` action.
- Reference behavior from Cat Gatekeeper Chrome listing:
  - Default usage limit: 60 minutes.
  - Default break time: 5 minutes.
  - A cat overlay appears when time is up.
  - Chrome version only counts supported social media tabs while active.
  - Source: https://chromewebstore.google.com/detail/cat-gatekeeper/elbikiflgfhjdjmficnigpeegjbhdidh

## Important Paths

- `docs/ARCHITECTURE.md` - current technical direction.
- `docs/ROADMAP.md` - likely project sequence.
- `docs/product/specs/SPEC-0001-cat-break-mvp.md` - MVP product spec.
- `docs/product/plans/PLAN-0001-native-macos-prototype/PLAN-0001-native-macos-prototype.md` - first implementation plan.
- `docs/product/plans/PLAN-0001-native-macos-prototype/IMPL-0001-01-scaffold-native-macos-prototype.md` - first implementation brief.
- `docs/plans/` - add implementation plans when work becomes multi-step.
- `docs/decisions/` - add short ADR-style notes for durable choices.
- `docs/session-logs/` - add receipts for meaningful work sessions.
- `scripts/docs-meta` - AGENT-DOCS metadata helper for IDs and generated views.

## Current Risks

- System-wide interruption on macOS can become annoying or permission-heavy if designed too aggressively.
- Cat video sourcing needs licensing clarity before shipping.
- Transparent/chroma-key video overlay feasibility should be prototyped before investing in polish.

## Verification

- `swift test` passes for the initial package and core timer tests.

## Next Best Step

- Run the manual smoke flow on macOS with `swift run CatBreak`.
- Continue PLAN-0001 with deeper verification for timer-triggered overlay, idle pause behavior, and overlay behavior across Spaces/full-screen apps.
