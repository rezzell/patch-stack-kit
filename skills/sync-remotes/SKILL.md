---
name: sync-remotes
description: Use when adding or fetching remotes defined in the fork-maintenance manifest.
---

# Sync Remotes

Read [the shared reference](../../references/fork-maintenance.md), then add or fetch the remotes defined in the manifest without changing the canonical workflow order.

When this step is part of full maintenance:

- Run it after local `main` has been synced from `upstream/main` and `origin/main`.
- Confirm whether `origin/main` matches the synced local `main` commit.
- If `origin/main` is stale and the workflow cannot update it, stop and report that explicitly instead of continuing with a stale integration base.

Use this skill when the user wants only the remote sync step.
