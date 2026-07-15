---
name: fork-maintenance
description: Use when maintaining a downstream fork from a patch-stack manifest, including upstream sync, remote sync, feature branch tracking, integration/latest rebuilds, and stack inspection.
---

# Fork Maintenance

## Overview

This is the package-manager entry point for the fork-maintenance bundle. Read the shared reference, then run the workflow in the exact order documented there. Do not improvise branch choices, manifest edit locations, or ending branches.

## Workflow

1. Read [the shared reference](references/fork-maintenance.md).
2. Resolve the current branch, whether it is already tracked, and whether the user wants it added when it is missing from the manifest.
3. Ask the user where the run should end before switching branches. Suggest the current branch, the manifest branch, or `integration/latest`.
4. Check out `main` and run the strict sync order from the shared reference: `upstream/main` when present, then `origin/main`, then alignment of `origin/main` with the synced local `main`.
5. Re-run manifest discovery after sync and use that result for the remaining steps.
6. Create or update tracked feature branches, including the current-branch adoption case when requested.
7. Rebuild `integration/latest` from the synced local `main` branch and the manifest entries in order.
8. List or inspect the resulting stack.
9. End on the branch the user selected at the start unless the workflow stopped on an error.

## Focused Steps

Use the bundled step files as focused procedure references when the user asks for only one part of the workflow:

- `skills/sync-upstream/SKILL.md`
- `skills/sync-remotes/SKILL.md`
- `skills/create-feature/SKILL.md`
- `skills/rebuild-integration/SKILL.md`
- `skills/list-features/SKILL.md`

## Output

- Report the manifest path, or state that bootstrap was required.
- Report whether the current branch was already tracked, newly added, or intentionally left out for this run.
- Report the chosen final branch before switching away from the starting branch.
- Report the synced `main` commit that became the integration base.
- Report commit IDs after sync or rebuild steps.
- Report conflicts immediately with the exact feature or commit range that failed.
