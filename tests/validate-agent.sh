#!/usr/bin/env bash
# Checks that a directory conforms to CONVENTIONS.md.
# Usage: tests/validate-agent.sh <agent-dir>
set -uo pipefail

DIR="${1:-}"
[ -n "$DIR" ] && [ -d "$DIR" ] || { echo "FAIL: not a directory: ${DIR:-<none>}"; exit 1; }

ERRORS=0
fail() { echo "FAIL: $1"; ERRORS=$((ERRORS + 1)); }

AGENT_HEADINGS=(
  "Identity" "Mission" "Inputs" "Outputs" "Operating rules" "Workflow"
  "Sub-agents" "Skills" "Guardrails / never do" "Escalate to human when"
)
SUBAGENT_HEADINGS=(
  "Purpose" "Trigger" "Inputs" "Outputs" "Tools allowed"
  "Stop conditions" "Handoff" "Inline fallback"
)
ADAPTER_MAX_LINES=25

# Required directories
for d in adapters skills subagents templates samples context evals; do
  [ -d "$DIR/$d" ] || fail "missing directory: $d/"
done

# Required files
[ -f "$DIR/AGENT.md" ]       || fail "missing AGENT.md"
[ -f "$DIR/install.sh" ]     || fail "missing install.sh"
[ -x "$DIR/install.sh" ]     || fail "install.sh is not executable"
[ -f "$DIR/evals/cases.md" ] || fail "missing evals/cases.md"
for a in CLAUDE GEMINI AGENTS; do
  [ -f "$DIR/adapters/$a.md" ] || fail "missing adapters/$a.md"
done

# AGENT.md headings present and in order
if [ -f "$DIR/AGENT.md" ]; then
  found=$(grep -E '^#{2,3} ' "$DIR/AGENT.md" | sed -E 's/^#+ +//' || true)
  expected=$(printf '%s\n' "${AGENT_HEADINGS[@]}")
  filtered=$(echo "$found" | grep -Fx -f <(printf '%s\n' "${AGENT_HEADINGS[@]}") || true)
  [ "$filtered" = "$expected" ] || fail "AGENT.md headings missing or out of order"
fi

# Adapters are pointers, not behavior
for a in CLAUDE GEMINI AGENTS; do
  f="$DIR/adapters/$a.md"
  [ -f "$f" ] || continue
  lines=$(wc -l < "$f" | tr -d ' ')
  [ "$lines" -le "$ADAPTER_MAX_LINES" ] \
    || fail "adapters/$a.md has $lines lines (max $ADAPTER_MAX_LINES) — adapters carry no behavior"
  grep -qF 'AGENT.md' "$f" || fail "adapters/$a.md does not point at AGENT.md"
done

# Skills: frontmatter shape
while IFS= read -r f; do
  [ -n "$f" ] || continue
  head -1 "$f" | grep -qx -- '---' || { fail "$f: missing opening frontmatter ---"; continue; }
  name=$(sed -n '2,10p' "$f" | grep -m1 '^name:' | sed 's/^name:[[:space:]]*//' || true)
  desc=$(sed -n '2,10p' "$f" | grep -m1 '^description:' | sed 's/^description:[[:space:]]*//' || true)
  [ -n "$name" ] || fail "$f: missing name in frontmatter"
  echo "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || fail "$f: name '$name' is not kebab-case"
  [ -n "$desc" ] || fail "$f: missing description in frontmatter"
  case "$desc" in
    "Use when"*) ;;
    *) fail "$f: description must begin with 'Use when'" ;;
  esac
done < <(find "$DIR/skills" -name SKILL.md 2>/dev/null)

# Sub-agent contracts: required headings
while IFS= read -r f; do
  [ -n "$f" ] || continue
  for h in "${SUBAGENT_HEADINGS[@]}"; do
    grep -qE "^#{2,3} +$h\$" "$f" || fail "$f: missing heading '$h'"
  done
done < <(find "$DIR/subagents" -name '*.md' 2>/dev/null)

if [ "$ERRORS" -eq 0 ]; then echo "OK: $DIR conforms"; exit 0; fi
echo "$ERRORS problem(s) in $DIR"; exit 1
