---
name: fork-maintenance
description: Use when running the full manifest-driven fork maintenance cycle across start-branch sync, remote sync, feature creation, finish-branch rebuild, and stack inspection.
---

# Fork Maintenance

## Overview

This is the orchestrator skill. Read the linked shared reference at `references/fork-maintenance.md` exactly, then run the full workflow in the exact order documented there. Do not search for alternate reference copies, improvise branch choices, manifest edit locations, or ending branches.

## When to Use

- The user wants the full fork maintenance cycle
- The user wants a guided sequence rather than one step
- The user wants the repo scripts applied in the right order

## Workflow

1. Read [the shared reference](references/fork-maintenance.md).
2. Resolve the manifest branch path: `path.start`, ordered `features`, and `path.finish`. For legacy manifests without `path`, use the documented defaults and report them.
3. Resolve the current branch, whether it is already tracked, and whether the user wants it added when it is missing from the manifest.
4. Ask the user where the run should end before switching branches. Suggest the current branch, the manifest branch, or `path.finish`.
5. Check out `path.start` and run the strict sync order from the shared reference: `upstream/<path.start>` when present, then `origin/<path.start>`, then alignment of `origin/<path.start>` with the synced local `path.start`.
6. Re-run manifest discovery after sync and use that result for the remaining steps.
7. Create or update tracked feature branches, including the current-branch adoption case when requested.
8. Rebuild `path.finish` from the synced local `path.start` branch and the manifest entries in order.
9. List or inspect the resulting stack.
10. End on the branch the user selected at the start unless the workflow stopped on an error.

## Step Skills

- `sync-upstream`
- `sync-remotes`
- `create-feature`
- `rebuild-integration`
- `list-features`

## Output

- Use the full cycle when the user asks for maintenance end-to-end.
- Delegate to a step skill when the user wants only one action.
- Report the manifest path, resolved branch path, whether the current branch was adopted into the stack, the synced `path.start` base commit, and the final branch selection.
