# 2026-04-28 - GitHub CLI Path Correction

## What happened

During the public repo setup, the shell command `command -v gh` returned nothing. I inferred that `gh` was unavailable and started using direct GitHub API calls. The user asked to use `gh`, and a broader search found `gh` installed at `/opt/homebrew/Cellar/gh/2.88.1/bin/gh` with `/opt/homebrew/bin/gh` symlinked to it.

## What led to it

The Codex shell PATH was:

```text
/Users/macintoso/.codex/tmp/arg0/codex-arg0YwbCwg:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Codex.app/Contents/Resources
```

That PATH omits Homebrew locations, so `command -v gh` was an incomplete availability check.

## Source

Tooling gap plus agent assumption. The shell environment hid Homebrew binaries, and I treated PATH lookup as authoritative too quickly.

## What changed

- Used the discovered `gh` binary directly for auth verification, Git credential setup, repository inspection, and push.
- Added a guardrail to the local `git-github` skill: check common Homebrew paths before saying `gh` is unavailable.

## Verification

- `/opt/homebrew/Cellar/gh/2.88.1/bin/gh auth status` showed an authenticated `owensantoso` account.
- `/opt/homebrew/Cellar/gh/2.88.1/bin/gh repo view owensantoso/cat-break` confirmed the repo is public with default branch `main`.
- `git push` succeeded after `gh auth setup-git`.

## Follow-up

For future GitHub tasks in Codex desktop, prefer this check order:

1. `command -v gh`
2. `/opt/homebrew/bin/gh`
3. `/usr/local/bin/gh`
4. `find /opt/homebrew /usr/local -path '*/bin/gh'`
