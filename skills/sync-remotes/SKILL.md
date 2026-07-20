---
name: sync-remotes
description: Use when adding or fetching remotes defined in the fork-maintenance manifest.
---

# Sync Remotes

Read [the shared reference](../../references/fork-maintenance.md), then add or fetch the remotes defined in the manifest without changing the canonical workflow order.

When this step is part of full maintenance:

- Run it after local `path.start` has been synced from `upstream/<path.start>` and `origin/<path.start>`.
- Confirm whether `origin/<path.start>` matches the synced local `path.start` commit.
- If `origin/<path.start>` is stale and the workflow cannot update it, stop and report that explicitly instead of continuing with a stale integration base.

Use this skill when the user wants only the remote sync step.
