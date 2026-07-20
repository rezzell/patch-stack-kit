---
name: sync-upstream
description: Use when fast-forwarding the manifest start branch from upstream and origin.
---

# Sync Upstream

Read [the shared reference](../../references/fork-maintenance.md), then sync `path.start` using the strict order from the shared contract:

1. Check out local `path.start`.
2. Fetch and fast-forward from `upstream/<path.start>` when remote `upstream` exists.
3. Fetch `origin/<path.start>`.
4. Fast-forward local `path.start` from `origin/<path.start>` when that is newer and still fast-forward compatible.
5. If both remotes exist, ensure `origin/<path.start>` is aligned with the synced local `path.start` commit or stop and report why it is not.

Use the resulting synced local `path.start` commit as the authoritative base for any later feature updates or `path.finish` rebuild.

Use this skill when the user wants only the upstream sync step, not the full cycle.
