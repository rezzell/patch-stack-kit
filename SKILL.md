---
name: fork-maintenance
description: Use when maintaining a downstream fork from a patch-stack manifest, including start-branch sync, remote sync, feature branch tracking, finish-branch rebuilds, and stack inspection.
---

# Fork Maintenance

## Overview

This is the package-manager entry point for the fork-maintenance bundle. Read the linked shared reference at `references/fork-maintenance.md` exactly, then run the workflow in the exact order documented there. Do not search for alternate reference copies, improvise branch choices, manifest edit locations, or ending branches.

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

## Focused Steps

Use the bundled step files as focused procedure references when the user asks for only one part of the workflow:

- `skills/sync-upstream/SKILL.md`
- `skills/sync-remotes/SKILL.md`
- `skills/create-feature/SKILL.md`
- `skills/rebuild-integration/SKILL.md`
- `skills/list-features/SKILL.md`

## Output

- Report the manifest path, or state that bootstrap was required.
- Report the resolved branch path: start branch, ordered feature patches, and finish branch.
- Report whether the current branch was already tracked, newly added, or intentionally left out for this run.
- Report the chosen final branch before switching away from the starting branch.
- Report the synced `path.start` commit that became the integration base.
- Report commit IDs after sync or rebuild steps.
- Report conflicts immediately with the exact feature or commit range that failed.
