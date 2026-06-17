---
name: fork-maintenance
description: Use when running the full manifest-driven fork maintenance cycle across upstream sync, remote sync, feature creation, integration rebuild, and stack inspection.
---

# Fork Maintenance

## Overview

This is the orchestrator skill. Read the shared reference, then call the step-level skills in sequence when the user wants the full maintenance cycle.

## When to Use

- The user wants the full fork maintenance cycle
- The user wants a guided sequence rather than one step
- The user wants the repo scripts applied in the right order

## Workflow

1. Read [the shared reference](../../references/fork-maintenance.md).
2. Sync upstream.
3. Sync remotes.
4. Create features if requested.
5. Rebuild integration.
6. List or inspect the resulting stack.

## Step Skills

- `sync-upstream`
- `sync-remotes`
- `create-feature`
- `rebuild-integration`
- `list-features`

## Output

- Use the full cycle when the user asks for maintenance end-to-end.
- Delegate to a step skill when the user wants only one action.
