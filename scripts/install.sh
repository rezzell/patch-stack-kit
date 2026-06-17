#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/install.sh [codex|claude|both|project <repo-root>] [--copy]

Options:
  --copy   Copy files instead of creating symlinks
EOF
}

mode="${1:-}"
copy_mode=0

if [[ -z "$mode" ]]; then
  usage
  exit 1
fi

shift || true
project_root=""
if [[ "$mode" == "project" ]]; then
  project_root="${1:-}"
  if [[ -z "$project_root" ]]; then
    echo "project mode requires a repository root path" >&2
    usage
    exit 1
  fi
  shift || true
fi

for arg in "$@"; do
  case "$arg" in
    --copy)
      copy_mode=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_src_root="$repo_root/skills"
refs_src_root="$repo_root/references"

copy_or_link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  if [[ "$copy_mode" -eq 1 ]]; then
    cp -R "$src" "$dest"
  else
    ln -s "$src" "$dest"
  fi
}

install_bundle() {
  local dest_root="$1"
  local skills_dest_root="$dest_root/skills"
  local refs_dest_root="$dest_root/references"
  local skill_src

  mkdir -p "$skills_dest_root" "$refs_dest_root"

  for skill_src in "$skills_src_root"/*; do
    [[ -d "$skill_src" ]] || continue
    copy_or_link "$skill_src" "$skills_dest_root/$(basename "$skill_src")"
  done

  copy_or_link "$refs_src_root" "$refs_dest_root"
}

codex_root="${CODEX_HOME:-$HOME/.codex}"
claude_root="$HOME/.claude"

case "$mode" in
  codex)
    install_bundle "$codex_root"
    echo "Installed Codex skills under $codex_root/skills"
    echo "Installed shared references under $codex_root/references"
    ;;
  claude)
    install_bundle "$claude_root"
    echo "Installed Claude skills under $claude_root/skills"
    echo "Installed shared references under $claude_root/references"
    ;;
  both)
    install_bundle "$codex_root"
    install_bundle "$claude_root"
    echo "Installed Codex skills under $codex_root/skills"
    echo "Installed shared references under $codex_root/references"
    echo "Installed Claude skills under $claude_root/skills"
    echo "Installed shared references under $claude_root/references"
    ;;
  project)
    install_bundle "$project_root/.codex"
    echo "Installed project-local skills under $project_root/.codex/skills"
    echo "Installed shared references under $project_root/.codex/references"
    if [[ ! -f "$project_root/CLAUDE.md" ]]; then
      cp "$repo_root/CLAUDE.md" "$project_root/CLAUDE.md"
      echo "Installed $project_root/CLAUDE.md"
    else
      echo "$project_root/CLAUDE.md already exists; leaving it unchanged"
    fi
    ;;
  *)
    usage
    exit 1
    ;;
esac
