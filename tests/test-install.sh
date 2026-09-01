#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
source tests/lib.sh

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# Symlink mode: adapters appear at the agent root as links.
cp -R _template "$WORK/link-agent"
( cd "$WORK/link-agent" && ./install.sh >/dev/null 2>&1 )
for f in CLAUDE.md GEMINI.md AGENTS.md; do
  if [ -L "$WORK/link-agent/$f" ]; then _report ok "$f is a symlink"
  else _report no "$f is not a symlink"; fi
done
if [ -f "$WORK/link-agent/.claude/agents" ] || [ -d "$WORK/link-agent/.claude" ]; then
  _report ok ".claude/ created"
else _report no ".claude/ missing"; fi

# Copy mode: real files that survive the source being deleted.
cp -R _template "$WORK/copy-agent"
( cd "$WORK/copy-agent" && ./install.sh --copy >/dev/null 2>&1 )
for f in CLAUDE.md GEMINI.md AGENTS.md; do
  if [ -f "$WORK/copy-agent/$f" ] && [ ! -L "$WORK/copy-agent/$f" ]; then
    _report ok "$f is a real file"
  else _report no "$f is not a real file"; fi
done
rm -rf "$WORK/copy-agent/adapters"
assert_contains "$WORK/copy-agent/CLAUDE.md" "AGENT.md"

# Idempotence: a second run must not fail or nest links.
( cd "$WORK/link-agent" && ./install.sh >/dev/null 2>&1 )
assert_pass test -L "$WORK/link-agent/CLAUDE.md"

# Dry run writes nothing.
cp -R _template "$WORK/dry-agent"
( cd "$WORK/dry-agent" && ./install.sh --dry-run >/dev/null 2>&1 )
assert_fail test -e "$WORK/dry-agent/CLAUDE.md"

finish
