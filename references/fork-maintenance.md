# Fork Maintenance Reference

This repository defines a manifest-driven workflow for maintaining a downstream fork.

## Shared Source of Truth

- `patch-stack.yaml` describes upstream, integration, remotes, and features.
- All skills in this bundle use the same manifest and command conventions.

## Canonical Step Order

1. Sync upstream into `main`.
2. Sync remotes.
3. Create or update tracked feature branches.
4. Rebuild `integration/latest`.
5. List or inspect the current feature stack.

## Safety Rules

- Fast-forward `main` only.
- Never hand-edit `integration/latest`.
- Preserve `order`, `depends_on`, and `pinned_commits`.
- Stop on conflicts and report the exact feature or commit range that failed.
- Use dry-run mode first when the action is destructive or uncertain.

## Output Expectations

- Report commit IDs after sync or rebuild steps.
- Report conflicts immediately.
- Keep the manifest as the source of truth for active features and ordering.
