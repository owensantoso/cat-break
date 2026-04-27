---
type: diagnostic-record
id: DIAG-0001
title: Prototype Runtime Tracing
domain: repo-health
status: investigating
created_at: "2026-04-28 01:50:19 JST +0900"
updated_at: "2026-04-28 01:50:19 JST +0900"
owner: 
symptom: Need to tell whether the prototype launched, timer started, break triggered, overlay showed, snooze fired, or overlay hid during manual smoke testing.
artifact_root: artifacts/diagnostics/DIAG-0001/
privacy_classification: public-metadata
artifact_sensitivity: local-runtime-logs
safe_to_commit: false
retention_policy:
delete_after:
capture_method: macOS unified logging via OSLog plus optional JSONL via CATBREAK_TRACE_PATH
raw_artifacts_local_only:
  - /tmp/catbreak-trace.jsonl
  - artifacts/diagnostics/DIAG-0001/
sanitized_artifacts: []
environment:
git_sha:
app_build:
related_evaluations: []
related_adrs: []
related_specs: []
related_plans: []
related_sessions: []
linked_paths: []
repo_state:
  based_on_commit: ac5428dd408b51032864abdcea544cd32f8c2c36
  last_reviewed_commit: ac5428dd408b51032864abdcea544cd32f8c2c36
---

# DIAG-0001 - Prototype Runtime Tracing

## Symptom

The first prototype needs a quick way to answer: did the app start, did the timer begin ticking, did `Cat Now` or timer start a break, did the overlay show, and did snooze/hide events happen?

## Run Context

- App: `CatBreak`
- Subsystem: `com.owensantoso.CatBreak`
- Category: `PrototypeRuntime`
- Diagnostic ID: `DIAG-0001`
- Run ID: generated on process start as `run-YYYYMMDD-HHMMSS`
- Optional JSONL path: set `CATBREAK_TRACE_PATH`

## Instrumentation Added

- `Diagnostics` helper emits OSLog events with `diag_id` and `run_id`.
- `Diagnostics` also writes structured JSONL when `CATBREAK_TRACE_PATH` is set.
- Events added:
  - `app.started`
  - `settings.changed`
  - `timer.ticking_started`
  - `break.started`
  - `break.finished`
  - `break.snoozed`
  - `timer.reset`
  - `overlay.shown`
  - `overlay.hidden`

## Evidence

Live stream while testing:

```bash
log stream --style compact --predicate 'subsystem == "com.owensantoso.CatBreak" AND category == "PrototypeRuntime"'
```

Show recent events after a run:

```bash
log show --last 10m --style compact --predicate 'subsystem == "com.owensantoso.CatBreak" AND category == "PrototypeRuntime"'
```

Run the prototype:

```bash
swift run CatBreak
```

Run with local JSONL trace capture:

```bash
rm -f /tmp/catbreak-trace.jsonl
CATBREAK_TRACE_PATH=/tmp/catbreak-trace.jsonl swift run CatBreak
cat /tmp/catbreak-trace.jsonl
```

Suggested committed-safe artifact location for sanitized/manual runs:

```text
artifacts/diagnostics/DIAG-0001/run-YYYYMMDD-HHMMSS-zone/trace.jsonl
```

The `artifacts/` directory is ignored by Git so raw traces stay local by default.

## Key Events

Expected manual smoke sequence:

1. `app.started`
2. `timer.ticking_started`
3. `break.started trigger=cat_now`
4. `overlay.shown`
5. `break.snoozed`
6. `overlay.hidden`
7. after snooze duration, `break.started trigger=timer`
8. `overlay.shown`

## Current Theory / Root Cause

No failure is diagnosed yet. This record adds visibility so manual smoke failures can be localized to app launch, timer scheduling, overlay presentation, or controls.

## Fix Or Next Instrumentation

- If the app does not show a window, inspect `app.started` and app process state.
- If `Cat Now` does nothing, inspect `break.started trigger=cat_now`.
- If break starts but no overlay appears, inspect `overlay.shown`.
- If snooze does nothing, inspect `break.snoozed` and `overlay.hidden`.

## Privacy Notes

- Logs contain timing values, settings durations, event names, run IDs, and overlay frame size.
- Logs do not contain user content, file paths, secrets, keystrokes, app names, URLs, location, or raw private data.
- Raw OSLog exports should stay local unless sanitized excerpts are explicitly needed.
- JSONL traces are safe metadata, but still marked `safe_to_commit=false` by default to avoid accidentally committing local run context.

## Cleanup Plan

- Keep this instrumentation through the prototype phase.
- Revisit once the app has a proper debug/export surface.
- Raw traces are local/private by default. Commit only sanitized excerpts or metadata needed to understand the diagnosis.
