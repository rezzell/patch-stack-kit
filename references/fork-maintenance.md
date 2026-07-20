# Fork Maintenance Reference

This repository defines a manifest-driven workflow for maintaining a downstream fork.

## Shared Source of Truth

- `patch-stack.yaml` describes upstream, remotes, the branch path, and features.
- All skills in this bundle use the same manifest and command conventions.

## Manifest Branch Path

Every new or edited `patch-stack.yaml` must declare the branch path explicitly:

```yaml
path:
  start: main
  finish: integration/latest
features:
  - branch: feature/example
```

Path fields:

- `path.start` is the branch the stack starts from. Sync this branch before feature updates and use its synced commit as the integration rebuild base.
- `features` is the ordered list of patch branches to apply. Treat each feature entry as one patch in the stack.
- `path.finish` is the branch that receives the fully rebuilt stack after all active feature entries have been applied.

The deterministic branch path is always:

`path.start` -> each active `features[].branch` entry in manifest order -> `path.finish`

Do not infer `path.start` from the branch where the user begins the run. The starting worktree branch is only the branch admission candidate. If the user has just committed work on that branch and wants it tracked, add that same branch to `features`; still start the rebuild from `path.start`.

For legacy manifests that do not yet include `path`, use `main` as `path.start` and `integration/latest` as `path.finish`, report that legacy defaults were used, and add the explicit `path` block the next time the manifest is edited.

If a manifest has a `path` block, both `path.start` and `path.finish` are required. Stop before branch switching when either field is missing.

## Manifest Discovery

Every fork-maintenance skill must resolve the manifest using the same ordered lookup:

1. `.codex/patch-stack.yaml`
2. `.claude/patch-stack.yaml`
3. `.agents/patch-stack.yaml`
4. `patch-stack.yaml` in the repository root

The three agent-specific paths are a conflict set:

- `.codex/patch-stack.yaml`
- `.claude/patch-stack.yaml`
- `.agents/patch-stack.yaml`

If more than one of those three files exists, stop immediately and report the exact conflicting paths. Do not choose one by precedence.

If exactly one agent-specific manifest exists, use it.

If none exists, fall back to repo-root `patch-stack.yaml`.

Legacy paths such as `manifests/patch-stack.yaml` are not part of the supported discovery flow.

## Bootstrap Fallback

If no supported manifest exists in the working tree, the workflow must check for branch `fork-maintenance/bootstrap`.

If that branch exists:

- Use it as the bootstrap source.
- Import its full tree into the target branch as the first maintenance commit.
- Preserve imported paths exactly as stored on the bootstrap branch.
- Continue normal processing using the manifest path exactly as it exists in the imported tree.

If that branch does not exist, stop immediately and report the checked manifest paths plus the missing bootstrap branch name.

## Current Branch Admission

Before any skill switches branches for sync, manifest edits, or rebuild work, it must inspect the current branch and compare it with the manifest entries.

Preflight rules:

- Resolve the manifest path first using the shared discovery rules above.
- If discovery says bootstrap is required, complete bootstrap import first, then resume current-branch admission using the imported manifest path.
- Determine the current branch name before checking out anything else.
- If the current branch is already listed in the manifest feature stack, continue normally.
- If the current branch is `path.start`, `path.finish`, or the bootstrap branch, continue normally.
- If the current branch is not listed in the manifest, stop and ask the user whether they want that branch added to the manifest, ignored for this run, or whether the run should stop.

If the user wants the current branch added to the stack:

- Do not create a second branch just to represent the current work.
- Add the existing current branch to the manifest as the tracked feature branch.
- Use the resolved manifest path to decide where that edit must happen.

Manifest edit location rules:

- If the resolved manifest is only a local working-tree file on the current branch, edit that file in place and add the current branch there.
- If the manifest change belongs to committed history on another branch, require the current branch to be clean before switching away.
- When a switch is required to edit the manifest, switch to the branch that carries the manifest change, update the manifest there, and avoid creating any extra bookkeeping branch.

## Branch Switching And End State

Any workflow that needs to leave the current branch must make the landing point explicit before the first checkout.

Required end-state prompt:

- Ask the user where they want to end up after the workflow completes.
- Suggest these destinations explicitly:
  - the current branch
  - the branch that carries the manifest update
  - the full maintenance landing point from `path.finish`

Do not guess the final branch from prior runs. Record the chosen destination and honor it at the end unless the workflow stops on an error first.

## Start Branch Sync Contract

After the current-branch decision is resolved, the full maintenance workflow switches to `path.start` and refreshes it in a strict order.

Required order:

1. Check out local `path.start`.
2. If remote `upstream` exists, fetch `upstream/<path.start>` and fast-forward local `path.start` from it.
3. Fetch `origin/<path.start>`.
4. Fast-forward local `path.start` from `origin/<path.start>` when that is newer and still fast-forward compatible.
5. If both `upstream/<path.start>` and `origin/<path.start>` exist, ensure `origin/<path.start>` is brought up to the chosen local `path.start` commit or stop and report why that sync could not be completed.

The result of this step must be one clean local `path.start` branch that reflects the most up-to-date fast-forwardable history from `upstream/<path.start>` and `origin/<path.start>`.

## Authoritative Post-Sync Discovery

The full maintenance workflow performs manifest discovery twice:

- a preflight discovery before current-branch admission
- an authoritative discovery after `path.start` has been synced

The post-sync discovery result is the one used for feature updates and for rebuilding `path.finish`.

Re-resolve the branch path from the post-sync manifest. If the authoritative manifest changes `path.start` or `path.finish`, report the updated branch path before continuing.

## Canonical Step Order

1. Resolve the current branch, manifest location, branch path, and desired end state.
2. Sync local `path.start` from `upstream/<path.start>` when present, then from `origin/<path.start>`.
3. Sync remotes and ensure `origin/<path.start>` is current with the synced `path.start` commit.
4. Re-run manifest discovery from the synced repository state.
5. Create or update tracked feature branches.
6. Rebuild `path.finish` from the synced local `path.start` branch and the active manifest entries in order.
7. End on the branch the user selected at the start.

## Safety Rules

- Fast-forward `path.start` only during the start-branch sync step.
- Never create an extra branch when the user wants the current branch added to the manifest.
- Never hand-edit `path.finish`.
- Never assume another skill invocation has already prepared the repository.
- Preserve `path`, `order`, `depends_on`, and `pinned_commits`.
- Preserve imported bootstrap paths as-is; do not rewrite manifest locations after import.
- Require a clean current branch before switching away to edit a manifest that lives on another branch.
- Rebuild `path.finish` from synced local `path.start`, never by incrementally editing the previous `path.finish`.
- Stop on conflicts and report the exact feature or commit range that failed.
- Stop on manifest discovery or bootstrap failure before running sync, feature creation, rebuild, or list operations.
- Use dry-run mode first when the action is destructive or uncertain.

## Output Expectations

- Report the resolved manifest path, or state that bootstrap was required.
- If bootstrap is used, report the bootstrap branch name.
- Report whether the current branch was already tracked, newly added, or intentionally left out for this run.
- Report the resolved branch path before switching away from the starting branch.
- Report the chosen final branch before switching away from the starting branch.
- Report the synced `path.start` commit that became the integration base.
- Report commit IDs after sync or rebuild steps.
- Report conflicts immediately.
- Keep the manifest as the source of truth for active features and ordering.
