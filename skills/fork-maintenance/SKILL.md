---
name: fork-maintenance
description: Use when running the full manifest-driven fork maintenance cycle across upstream sync, remote sync, feature creation, integration rebuild, and stack inspection.
---

# Fork Maintenance

## Overview

This is the orchestrator skill. Read the shared reference, then run the full workflow in the exact order documented there. Do not improvise branch choices, manifest edit locations, or ending branches.

## When to Use

- The user wants the full fork maintenance cycle
- The user wants a guided sequence rather than one step
- The user wants the repo scripts applied in the right order

## Workflow

1. Read [the shared reference](../../references/fork-maintenance.md).
2. Resolve the current branch, whether it is already tracked, and whether the user wants it added when it is missing from the manifest.
3. Ask the user where the run should end before switching branches. Suggest the current branch, the manifest branch, or `integration/latest`.
4. Check out `main` and run the strict sync order from the shared reference: `upstream/main` when present, then `origin/main`, then alignment of `origin/main` with the synced local `main`.
5. Re-run manifest discovery after sync and use that result for the remaining steps.
6. Create or update tracked feature branches, including the current-branch adoption case when requested.
7. Rebuild `integration/latest` from the synced local `main` branch and the manifest entries in order.
8. List or inspect the resulting stack.
9. End on the branch the user selected at the start unless the workflow stopped on an error.

## Step Skills

- `sync-upstream`
- `sync-remotes`
- `create-feature`
- `rebuild-integration`
- `list-features`

## Output

- Use the full cycle when the user asks for maintenance end-to-end.
- Delegate to a step skill when the user wants only one action.
- Report the manifest path, whether the current branch was adopted into the stack, the synced `main` base commit, and the final branch selection.
