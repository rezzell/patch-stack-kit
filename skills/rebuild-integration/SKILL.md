---
name: rebuild-integration
description: Use when reconstructing integration/latest from the active feature stack.
---

# Rebuild Integration

Read [the shared reference](../../references/fork-maintenance.md), then rebuild `integration/latest` using the post-sync manifest and the synced local `main` branch as the only allowed base.

Rebuild rules:

- Re-run manifest discovery after the `main` sync step and use that result for the rebuild.
- Start from the synced local `main` commit, not from the previous `integration/latest` tip.
- Apply the active manifest entries in order.
- Stop on the first conflict and report the exact feature or commit range that failed.
- Honor the final branch destination the user chose before branch switching began.

Use this skill when the user wants only the integration rebuild step.
