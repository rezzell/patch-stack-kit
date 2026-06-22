---
name: sync-upstream
description: Use when fast-forwarding main from upstream and rebasing local feature branches.
---

# Sync Upstream

Read [the shared reference](../../references/fork-maintenance.md), then sync `main` using the strict order from the shared contract:

1. Check out local `main`.
2. Fetch and fast-forward from `upstream/main` when remote `upstream` exists.
3. Fetch `origin/main`.
4. Fast-forward local `main` from `origin/main` when that is newer and still fast-forward compatible.
5. If both remotes exist, ensure `origin/main` is aligned with the synced local `main` commit or stop and report why it is not.

Use the resulting synced local `main` commit as the authoritative base for any later feature updates or `integration/latest` rebuild.

Use this skill when the user wants only the upstream sync step, not the full cycle.
