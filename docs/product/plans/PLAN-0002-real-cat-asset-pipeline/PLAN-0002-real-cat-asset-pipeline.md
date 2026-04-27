---
type: plan
id: PLAN-0002
title: Real Cat Asset Pipeline
domain: product
status: draft
created_at: "2026-04-28 02:28:07 JST +0900"
updated_at: "2026-04-28 02:30:00 JST +0900"
owner:
sequence:
  roadmap:
  sort_key:
  lane: product
  after:
    - PLAN-0001
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
  based_on_commit: c9eff40919b8e178efa41183b077a3a645f71544
  last_reviewed_commit: c9eff40919b8e178efa41183b077a3a645f71544
---

# PLAN-0002 - Real Cat Asset Pipeline

## Goal

Replace the ASCII placeholder cat with a real, license-safe cat asset pipeline that can support experimentation with sprites first and video/vector options later.

## Architecture

- Keep the overlay behavior from `PLAN-0001` intact.
- Start with a CC0 sprite or PNG-frame cat asset that can be committed to the public repo.
- Add asset provenance docs before or with the asset.
- Keep rendering swappable so future implementations can try green-screen video, transparent video, Lottie/Rive, or user-provided cats without rewriting break/timer logic.
- Prefer a simple SwiftUI animation for the first real cat.

## Task Dependencies / Parallelization

- Licensing/provenance comes first; do not import unclear assets.
- Asset import and renderer changes can happen together once the source asset is chosen.
- Future video/vector pipelines should be separate implementation briefs after the sprite path works.
- Net: pick CC0 asset, document provenance, add sprite renderer, verify overlay/manual smoke.

## Implementation Tasks

### Task 1: Choose a CC0 sprite asset

**Goal:** Select an asset that can be safely committed and redistributed.

- Prefer OpenGameArt CC0 cat sprite sources.
- Record source URL, author/handle if available, license, and download date.
- Avoid YouTube/TikTok/random green-screen clips unless explicit compatible licensing exists.

### Task 2: Add third-party asset documentation

**Goal:** Make asset provenance auditable.

- Add `THIRD_PARTY_ASSETS.md` or equivalent asset registry.
- Include license obligations even when attribution is not required.
- Keep raw local experiments out of Git unless license-safe.

### Task 3: Add sprite asset resources

**Goal:** Bundle the first real cat in the Swift package.

- Add transparent PNG frames or a sprite sheet under `Sources/CatBreak/Resources/`.
- Keep filenames stable and descriptive.
- Do not remove placeholder fallback until the sprite renderer works.

### Task 4: Replace placeholder overlay rendering

**Goal:** Show an animated cat sprite in the break overlay.

- Add a small renderer/view for the cat asset.
- Make the cat visually large enough to feel like the product idea.
- Preserve countdown and snooze controls.
- Keep the renderer isolated from timer and overlay-window ownership.

### Task 5: Verify and document experiments

**Goal:** Confirm the asset path works and future cat experiments have a clear next seam.

- Run build/tests/docs checks.
- Manual smoke `Cat Now` with the sprite visible.
- Update current state and implementation brief.

## Validation

- `swift test`
- `swift build`
- `scripts/docs-meta check`
- `scripts/docs-meta check-links`
- Manual smoke: launch app, click `Cat Now`, confirm sprite cat animates and controls still work.

## Completion Criteria

- A license-safe real cat asset is documented.
- The app bundles and renders a real animated cat sprite instead of ASCII placeholder text.
- The countdown, snooze, and overlay enforcement behavior from `PLAN-0001` still work.
- Future asset experiments have an obvious renderer/resource seam.
