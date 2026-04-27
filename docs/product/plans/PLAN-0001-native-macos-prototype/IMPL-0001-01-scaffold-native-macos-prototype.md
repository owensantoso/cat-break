---
type: implementation-brief
id: IMPL-0001-01
title: Scaffold Native macOS Prototype
domain: product
status: completed
created_at: "2026-04-28 00:56:09 JST +0900"
updated_at: "2026-04-28 01:43:08 JST +0900"
parent_plan: PLAN-0001
task_refs:
  - PLAN-0001#task-1
  - PLAN-0001#task-2
  - PLAN-0001#task-3
owner:
areas: []
depends_on: []
parallel_with: []
related_specs:
  - SPEC-0001
related_adrs: []
related_sessions: []
related_issues: []
related_prs: []
linked_paths:
  - docs/product/plans/PLAN-0001-native-macos-prototype/PLAN-0001-native-macos-prototype.md
  - docs/product/specs/SPEC-0001-cat-break-mvp.md
repo_state:
  based_on_commit:
  last_reviewed_commit: a046a38ba2221ba5a34431ed9d6aee2c357bb18e
---

# IMPL-0001-01 - Scaffold Native macOS Prototype

## Parent Plan

- [PLAN-0001 - Native macOS Prototype](PLAN-0001-native-macos-prototype.md)

## Task Goal

Create the initial native macOS app scaffold and prove the manual overlay path before relying on timer behavior.

After this task:

- The app can launch locally.
- The user can see a settings/menu surface with time remaining placeholder/state.
- The user can click `Cat Now` to show a placeholder cat overlay on the main display.

## Scope

In scope:

- Native macOS project scaffold.
- Settings model defaults needed by the first prototype.
- Manual overlay trigger.
- Placeholder cat overlay on main display.
- Initial verification commands or manual smoke steps.

Out of scope:

- App/site-aware detection.
- Multiple displays.
- Real cat video/chroma-key pipeline.
- Polished settings UX.

## Execution Steps

### 1. Choose and create app scaffold

Pick the smallest native macOS structure that can be built and launched locally.

### 2. Add settings defaults

Represent work interval, break duration, timing mode, idle threshold, snooze duration, and snooze limit with MVP defaults.

### 3. Add manual trigger surface

Expose a visible `Cat Now` action and time-remaining display area, even if timer internals are initially stubbed.

### 4. Add main-display overlay

Create a borderless/transparent overlay window on the main display and render placeholder cat content with countdown/snooze controls.

### 5. Document verification

Update implementation docs with the actual build/test command once the scaffold exists.

## Verification

Run once scaffold exists:

```bash
swift test
swift run CatBreak
```

Manual smoke:

- Launch app with `swift run CatBreak`.
- Click `Cat Now`.
- Confirm overlay appears above normal apps on the main display.
- Confirm countdown is visible.
- Confirm snooze can be used once by default.
- Optional quick timer smoke: click `Short Test Settings`, wait 15 seconds, and confirm the overlay appears.

## Done Checklist

- [x] App scaffold exists.
- [x] Settings defaults exist.
- [x] `Cat Now` action exists.
- [x] Main-display placeholder overlay appears.
- [x] Countdown is visible.
- [x] One-snooze behavior exists.
- [x] Verification command/manual smoke is documented.
