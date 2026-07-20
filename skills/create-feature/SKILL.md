---
name: create-feature
description: Use when creating a new tracked feature branch and manifest entry.
---

# Create Feature

Read [the shared reference](../../references/fork-maintenance.md), then handle one of these cases explicitly:

1. Create a new tracked feature branch when the user wants a brand-new branch.
2. Adopt the current branch into the manifest when the user is already on the branch they want tracked.

For the current-branch adoption case:

- Resolve the manifest path before editing anything.
- If the current branch is already listed in the manifest, do not create or add a duplicate entry.
- If the resolved manifest is only a local working-tree file on the current branch, edit it in place and add the current branch there.
- If the manifest update belongs on another branch, require the current branch to be clean before switching, then switch to the manifest branch and update the manifest there.
- Do not create an extra branch to represent work that already exists on the current branch.
- If a branch switch is needed, ask the user where they want the run to end before switching away. Suggest the current branch, the manifest branch, or `path.finish` when this step is part of the full maintenance flow.

Use this skill when the user wants only feature creation.
