#!/usr/bin/env bash
# Links this agent's adapters into the filenames each host looks for.
#   ./install.sh            symlink (default) — one copy of every fact on disk
#   ./install.sh --copy     independent copies, for handoff or link-averse hosts
#   ./install.sh --dry-run  print what would happen, write nothing
set -euo pipefail

cd "$(dirname "$0")"
MODE=link
for arg in "$@"; do
  case "$arg" in
    --copy)    MODE=copy ;;
    --dry-run) MODE=dry ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

[ -d adapters ] || { echo "no adapters/ directory here" >&2; exit 1; }

place() { # place <source> <destination>
  local src="$1" dest="$2"
  case "$MODE" in
    dry)  echo "would place $dest -> $src"; return ;;
    copy) rm -rf "$dest"; cp "$src" "$dest"; echo "copied  $dest" ;;
    link) rm -rf "$dest"; ln -s "$src" "$dest"; echo "linked  $dest" ;;
  esac
}

place adapters/CLAUDE.md CLAUDE.md
place adapters/GEMINI.md GEMINI.md
place adapters/AGENTS.md AGENTS.md

# Claude Code additionally discovers skills and agents by directory.
if [ "$MODE" != dry ]; then
  mkdir -p .claude
  rm -rf .claude/skills .claude/agents
  case "$MODE" in
    copy) cp -R skills .claude/skills; cp -R subagents .claude/agents ;;
    link) ln -s ../skills .claude/skills; ln -s ../subagents .claude/agents ;;
  esac
  echo "wired   .claude/skills and .claude/agents"
else
  echo "would wire .claude/skills and .claude/agents"
fi

echo "done ($MODE mode)"
