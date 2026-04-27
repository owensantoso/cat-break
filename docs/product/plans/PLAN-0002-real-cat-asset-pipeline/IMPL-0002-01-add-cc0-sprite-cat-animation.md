---
type: implementation-brief
id: IMPL-0002-01
title: Add CC0 Sprite Cat Animation
domain: product
status: draft
created_at: "2026-04-28 02:28:07 JST +0900"
updated_at: "2026-04-28 02:30:00 JST +0900"
parent_plan: PLAN-0002
task_refs:
  - PLAN-0002#task-1
  - PLAN-0002#task-2
  - PLAN-0002#task-3
  - PLAN-0002#task-4
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
  - docs/product/plans/PLAN-0002-real-cat-asset-pipeline/PLAN-0002-real-cat-asset-pipeline.md
  - docs/product/specs/SPEC-0001-cat-break-mvp.md
repo_state:
  based_on_commit: c9eff40919b8e178efa41183b077a3a645f71544
  last_reviewed_commit: c9eff40919b8e178efa41183b077a3a645f71544
---

# IMPL-0002-01 - Add CC0 Sprite Cat Animation

## Parent Plan

- [PLAN-0002 - Real Cat Asset Pipeline](PLAN-0002-real-cat-asset-pipeline.md)

## Task Goal

Replace the ASCII placeholder cat with a license-safe animated CC0 sprite cat while preserving the existing break overlay behavior.

After this task:

- The overlay displays a real animated cat sprite.
- Asset source and license are documented.
- The renderer remains small and swappable for future cat experiments.

## Scope

In scope:

- Select one CC0 cat sprite source.
- Add asset provenance docs.
- Add sprite resource files or a sprite sheet.
- Add a SwiftUI sprite renderer.
- Replace ASCII placeholder in `CatOverlayView` with the sprite renderer.
- Keep fallback behavior if resources fail to load.

Out of scope:

- Green-screen/chroma-key video.
- Transparent video pipeline.
- User-provided custom assets.
- Multi-cat asset picker.
- Paid stock assets or unclear licenses.

## Execution Steps

### 1. Confirm asset source and license

Use a clearly CC0 source, preferably OpenGameArt. Record source URL, author/handle if present, license, and download date before committing binary/image assets.

### 2. Add asset registry

Create `THIRD_PARTY_ASSETS.md` at the repo root or another clearly linked location. Include the chosen cat asset and any obligations.

### 3. Add sprite resources

Add the minimum resource files needed for the first animation under `Sources/CatBreak/Resources/`. Prefer transparent PNG frames or a simple sprite sheet.

### 4. Add sprite renderer

Create a small SwiftUI view that animates the sprite. Keep it independent from timer logic and overlay-window behavior.

### 5. Replace placeholder cat display

Update `CatOverlayView` to use the sprite renderer while preserving countdown, snooze, and styling.

### 6. Verify and update docs

Run verification, update current state, and mark this brief complete only after manual smoke confirms the sprite appears.

## Verification

Run:

```bash
swift test
swift build
scripts/docs-meta check
scripts/docs-meta check-links
```

Manual smoke:

- Launch with `CATBREAK_TRACE_PATH=/tmp/catbreak-trace.jsonl swift run CatBreak`.
- Click `Cat Now`.
- Confirm the sprite cat appears and animates.
- Confirm countdown still updates.
- Confirm `Snooze` still works.
- Confirm Alt-Tab overlay behavior is not regressed.

## Done Checklist

- [ ] CC0 cat asset selected.
- [ ] Asset provenance documented.
- [ ] Sprite resources added.
- [ ] Sprite renderer added.
- [ ] Overlay uses sprite renderer instead of ASCII placeholder.
- [ ] Countdown and snooze still work.
- [ ] Verification commands pass.
- [ ] Manual smoke completed or remaining manual gap documented.
