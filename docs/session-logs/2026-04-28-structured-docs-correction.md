# 2026-04-28 - Structured Docs Correction

## What happened

The initial docs pass created flat `docs/SPEC.md`, `docs/IMPL.md`, and a dated flat plan. The user clarified they meant AGENT-DOCS numbered source docs such as `SPEC-*`, `PLAN-*`, and `IMPL-*`.

## Source

Agent assumption/execution miss. The small AGENT-DOCS profile was installed, and the richer AGENT-DOCS source conventions in `/Users/macintoso/Documents/VSCode/AGENT-DOCS` were not inspected before creating files.

## What changed

- Removed the noncanonical flat `SPEC.md`, `IMPL.md`, and dated flat plan created in the previous pass.
- Installed `scripts/docs-meta` and `tests/docs-meta-smoke.sh`.
- Created canonical structured docs:
  - `docs/product/specs/SPEC-0001-cat-break-mvp.md`
  - `docs/product/plans/PLAN-0001-native-macos-prototype/PLAN-0001-native-macos-prototype.md`
  - `docs/product/plans/PLAN-0001-native-macos-prototype/IMPL-0001-01-scaffold-native-macos-prototype.md`
- Regenerated `docs/SPECS.md`, `docs/TODOS.md`, and other generated views with `scripts/docs-meta update`.
- Updated the local `new-project` skill to route AGENT-DOCS numbered docs through `structured-docs-workflow` and `docs-meta`.

## Verification

- `scripts/docs-meta check` passed.
- `scripts/docs-meta status` listed `SPEC-0001`, `PLAN-0001`, and `IMPL-0001-01`.
- `scripts/docs-meta show SPEC-0001` resolved the related plan and linked decision paths.
- `scripts/docs-meta check-links` passed.

## Gap

`tests/docs-meta-smoke.sh` did not run because this folder is not currently a Git repository; the smoke test calls `git rev-parse HEAD`.
