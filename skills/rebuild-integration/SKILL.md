---
name: rebuild-integration
description: Use when reconstructing the manifest finish branch from the active feature stack.
---

# Rebuild Integration

Read [the shared reference](../../references/fork-maintenance.md), then rebuild `path.finish` using the post-sync manifest and the synced local `path.start` branch as the only allowed base.

Rebuild rules:

- Re-run manifest discovery after the `path.start` sync step and use that result for the rebuild.
- Start from the synced local `path.start` commit, not from the previous `path.finish` tip.
- Apply the active manifest entries in order.
- Stop on the first conflict and report the exact feature or commit range that failed.
- Honor the final branch destination the user chose before branch switching began.

Use this skill when the user wants only the integration rebuild step.
