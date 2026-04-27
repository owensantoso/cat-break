---
type: plan
id: PLAN-0001
title: Native macOS Prototype
domain: product
status: draft
created_at: "2026-04-28 00:56:09 JST +0900"
updated_at: "2026-04-28 00:58:00 JST +0900"
owner:
sequence:
  roadmap:
  sort_key:
  lane: product
  after: []
  before: []
areas: []
related_specs:
  - SPEC-0001
related_adrs: []
related_sessions: []
related_issues: []
related_prs: []
linked_paths:
  - docs/product/specs/SPEC-0001-cat-break-mvp.md
repo_state:
  based_on_commit:
  last_reviewed_commit:
---

# PLAN-0001 - Native macOS Prototype

## Goal

Build the smallest native macOS prototype that proves Cat Break can trigger a large cat overlay through both a manual action and a timer.

## Architecture

- Use SwiftUI for settings/menu UI where it fits.
- Use AppKit where needed for overlay/window behavior.
- Keep timer logic separate from overlay presentation so `Cat Now` can test overlay behavior independently.
- Keep settings local and simple.

## Task Dependencies / Parallelization

- Foundation first: choose/create native project scaffold and basic app entry point.
- Timer and settings can be built after the app shell exists.
- Overlay work can proceed once the app can invoke a controller action.
- Verification should separately test manual overlay, timer trigger, snooze, and idle pause.
- Net: scaffold first, then split timer/settings and overlay concerns, then integrate.

## Implementation Tasks

### Task 1: Scaffold native macOS app

**Goal:** Create a minimal app shell that can run locally.

- Choose the project format.
- Add app entry point.
- Add a simple settings/menu surface.
- Avoid adding app/site-aware behavior.

### Task 2: Add settings and timer model

**Goal:** Represent the configurable break behavior.

- Include work interval, break duration, timing mode, idle threshold, snooze duration, and snooze limit.
- Provide defaults from SPEC-0001.
- Allow short test intervals.

### Task 3: Add overlay trigger path

**Goal:** Make `Cat Now` show the placeholder cat overlay on the main display.

- Keep overlay presentation independent from timer scheduling.
- Show countdown controls.
- Include one-snooze default behavior.

### Task 4: Add active-use timer

**Goal:** Trigger the overlay after accumulated active computer use.

- Support active-use and wall-clock modes.
- Pause active-use timing after the idle threshold.
- Show time remaining until next cat.

### Task 5: Verify prototype behavior

**Goal:** Prove the MVP loop works before polishing.

- Test manual overlay.
- Test short timer interval.
- Test snooze.
- Test idle pause.

## Validation

- Build and launch the app locally.
- Manual smoke: click `Cat Now` and confirm overlay behavior.
- Timer smoke: set a short interval and confirm timer-triggered overlay.
- Idle smoke: stop input past idle threshold and confirm countdown pauses in active-use mode.

## Completion Criteria

- `Cat Now` reliably shows the overlay on the main display.
- A short timer interval reliably triggers the overlay.
- Time remaining is visible.
- One-snooze-per-break behavior works with configurable values.
- Active-use timing and wall-clock timing can both be selected.
