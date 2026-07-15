# Fork Maintenance Skill

[![skills.sh](https://skills.sh/b/rezzell/patch-stack-kit)](https://skills.sh/rezzell/patch-stack-kit)

This repository is a source tree for a local Codex skill plus Claude Code install guidance.

## What is here

- `skills/fork-maintenance/SKILL.md`: orchestrator skill
- `skills/sync-upstream/SKILL.md`: step skill for upstream sync
- `skills/sync-remotes/SKILL.md`: step skill for remote sync
- `skills/create-feature/SKILL.md`: step skill for feature creation
- `skills/rebuild-integration/SKILL.md`: step skill for integration rebuild
- `skills/list-features/SKILL.md`: step skill for stack inspection
- `references/fork-maintenance.md`: shared manifest and workflow reference
- `SKILL.md`: package-manager entry point that keeps the bundle self-contained
- `apm.yml`: Agent Package Manager metadata
- `CLAUDE.md`: repo-local Claude Code instructions
- `scripts/install.sh`: installer for local machine or project copies

## Manifest Discovery And Bootstrap

All fork-maintenance skills share one manifest discovery contract.

Supported manifest locations, in order:

1. `.codex/patch-stack.yaml`
2. `.claude/patch-stack.yaml`
3. `.agents/patch-stack.yaml`
4. `patch-stack.yaml` in the repository root

If more than one agent-specific manifest exists, the run must fail instead of guessing.

If no supported manifest exists in the working tree, the skills must check for branch `fork-maintenance/bootstrap`. When present, that branch is imported as the bootstrap source and its paths are preserved exactly as stored. When absent, the run must stop and report the missing branch plus the checked manifest locations.

## Package Manager Install

These installs use the root `SKILL.md` bundle so `references/` and the focused step skills remain available together.

The npm-based CLIs currently expect a modern Node runtime; use Node 20 or newer, for example `nvm use 22`, if local `npx` execution fails.

### APM

```bash
apm install rezzell/patch-stack-kit
```

### skillfish / skill.fish

```bash
npx skillfish add rezzell/patch-stack-kit fork-maintenance
```

To submit or refresh the listing:

```bash
npx skillfish submit rezzell/patch-stack-kit
```

### skills.sh / `npx skills`

```bash
npx skills add rezzell/patch-stack-kit --skill fork-maintenance
```

## Local Install

### Codex

Install into your Codex skills directory:

```bash
./scripts/install.sh codex
```

By default this installs the skills under `$CODEX_HOME/skills` and the shared reference under `$CODEX_HOME/references`, falling back to `~/.codex/skills` and `~/.codex/references`.

### Claude Code

Install into your Claude skills directory:

```bash
./scripts/install.sh claude
```

This installs the skills under `~/.claude/skills` and the shared reference under `~/.claude/references`.

### Both

```bash
./scripts/install.sh both
```

### Project-local copy

If you want the skill inside another repository:

```bash
./scripts/install.sh project /path/to/other-repo
```

That installs all skills into `/path/to/other-repo/.codex/skills`, the shared reference into `/path/to/other-repo/.codex/references`, and copies `CLAUDE.md` if that file does not already exist. The target repository can keep its manifest in `.codex/patch-stack.yaml`, another supported agent-local location, or the repo root according to the shared discovery rules above.

## Notes

- The installer uses symlinks when possible.
- Pass `--copy` if you want a physical copy instead of a symlink.
- Restart Codex or reopen Claude Code after installing a new skill.
