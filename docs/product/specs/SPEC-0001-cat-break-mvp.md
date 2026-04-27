---
type: spec
id: SPEC-0001
title: Cat Break MVP
spec_type: feature
domain: product
status: draft
created_at: "2026-04-28 00:56:08 JST +0900"
updated_at: "2026-04-28 00:58:00 JST +0900"
owner:
source:
  type: conversation
  link:
  notes: Initial product shaping conversation for a native macOS version of Cat Gatekeeper-style breaks.
areas: []
related_plans:
  - PLAN-0001
related_issues: []
related_prs: []
related_adrs: []
related_sessions: []
supersedes: []
superseded_by: []
linked_paths:
  - docs/decisions/2026-04-28-break-enforcement.md
  - docs/decisions/2026-04-28-cat-media-placeholder-first.md
  - docs/decisions/2026-04-28-overlay-display-scope.md
  - docs/decisions/2026-04-28-testability-controls.md
  - docs/decisions/2026-04-28-timer-semantics.md
repo_state:
  based_on_commit:
  last_reviewed_commit:
---

# SPEC-0001 - Cat Break MVP

## Summary

Cat Break is a native macOS app that helps the user take regular breaks by interrupting long computer sessions with a large cat overlay. The MVP should prove the whole-system break loop before adding app/site-aware behavior or a real cat media pipeline.

## Problem / Opportunity

- Long computer sessions are easy to ignore until the user has already overworked.
- Browser-only interventions miss non-browser work and do not feel system-wide.
- A playful cat interruption can make a forced break feel less punitive.

## Goals

- Build a native macOS prototype that can trigger a break overlay manually and through a timer.
- Make the first prototype easy to test without waiting an hour.
- Keep the MVP whole-system rather than app/site-aware.
- Preserve a humane default: firm enough to create a break, not so strict it feels hostile.

## Non-Goals

- App/site-aware blocking.
- Multiple display support in the first prototype.
- Real green-screen/chroma-key video pipeline in the first prototype.
- Cloud sync, accounts, telemetry, or backend services.
- Polished cat media library.

## Current Behavior / Context

- No application code exists yet.
- The repo has AGENT-DOCS scaffolded and product decisions captured in `docs/decisions/`.
- The Chrome inspiration defaults to a 60-minute usage limit and 5-minute break, but only applies to selected social media tabs.

## Desired Behavior / Target State

- The app runs natively on macOS.
- The app tracks whole-system computer use, not specific apps or websites.
- The app shows a large cat overlay on the main display when a break starts.
- The user can see time remaining until the next cat.
- The user can trigger the overlay manually with `Cat Now`.

## Requirements

- Default work interval is 60 minutes of active computer use.
- Active-use timing pauses when the user has been idle for more than 2 minutes.
- A setting allows switching between active-use timing and wall-clock timing.
- Default break duration is 5 minutes.
- First prototype targets the main display only.
- First prototype uses a placeholder bundled cat asset.
- Break overlay shows a countdown.
- Default break behavior allows one 2-minute snooze per break.
- Work interval, break duration, timing mode, idle threshold, snooze duration, and snooze limit are configurable.
- Very short intervals are allowed for testing.
- Overlay triggering is testable independently from timer scheduling.

## Open Questions

- Exact native project format: Xcode app project vs. Swift Package/project-generation approach.
- Menu bar only vs. menu bar plus normal settings window.
- Placeholder cat asset format for the first prototype.

## Test / Validation Expectations

- Launch the app locally.
- Click `Cat Now` and confirm the overlay appears above normal apps on the main display.
- Confirm the break countdown and one-snooze behavior work.
- Set a short work interval and confirm the timer triggers the overlay.
- Stop input beyond the idle threshold and confirm active-use countdown pauses.

## Paper Trail

| Type | Link / Value | Role |
|---|---|---|
| Plan | PLAN-0001 | First implementation strategy |
| Decision | docs/decisions/2026-04-28-timer-semantics.md | Active-use timing default |
| Decision | docs/decisions/2026-04-28-break-enforcement.md | Snooze behavior |
| Decision | docs/decisions/2026-04-28-overlay-display-scope.md | Main-display-only prototype |
| Decision | docs/decisions/2026-04-28-cat-media-placeholder-first.md | Placeholder media first |
| Decision | docs/decisions/2026-04-28-testability-controls.md | Test controls |
