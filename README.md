# Webspenser Agent Library

A library of **portable agent specifications** — self-contained folders that
define an AI agent's identity, skills, sub-agent roles, and working
artifacts once, in a form that Claude Code, Gemini CLI, Codex, Cursor,
and comparable hosts can all load without duplication.

An agent specification here is not code. It is a directory of markdown
that any capable model can pick up and execute, plus thin adapter files
that let each host find it.

## Why this exists

Agent definitions tend to get written against one vendor's conventions
and then rewritten for the next. This library keeps a single source of
truth per agent and pushes provider differences into pointer files that
carry no behavior, so the same agent runs everywhere and drifts nowhere.

A specification is also portable in the ordinary sense: copy the folder
somewhere else, or hand it to a client, and it still works.

## Layout

```
agent-library/
  README.md
  CONVENTIONS.md            # the portable-agent standard, one page
  docs/superpowers/specs/   # design specs (framework, then one per agent)
  _template/                # empty skeleton — copy this to start an agent
  <agent-name>/
    AGENT.md                # single source of truth
    install.sh              # links adapters into host-expected locations
    adapters/               # CLAUDE.md, GEMINI.md, AGENTS.md — pointers only
    skills/                 # reusable procedures, SKILL.md format
    subagents/              # role contracts
    templates/              # blank artifacts the agent produces
    samples/                # filled gold-standard examples
    context/                # inputs the agent consumes
    evals/                  # given-X-expect-Y checks
```

## Using an agent

```bash
cd <agent-name>
./install.sh            # symlink adapters for detected hosts
./install.sh --copy     # independent copies, for handoff to a client
```

Then open the folder with any supported host and follow `AGENT.md`.

## Capability tiers

Agents declare the capability each workflow step needs, so weaker hosts
run a reduced agent rather than failing:

| Tier | Host capability | Behavior |
|---|---|---|
| 1 — Full | Sub-agent dispatch + skill autoloading | Sub-agents run dispatched and isolated |
| 2 — Reduced | No dispatch | Same role contracts run inline as sequential phases |
| 3 — Minimum | Single context | `AGENT.md` alone, skills pasted in as needed |

No step on any agent's critical path may require tier 1. Dispatch buys
parallelism and context isolation, never correctness.

## Creating a new agent

1. Read `CONVENTIONS.md`.
2. Copy `_template/` to `<agent-name>/`.
3. Write the design spec first, in `docs/superpowers/specs/`.
4. Fill in `AGENT.md`, then skills, then sub-agent contracts.
5. Write `evals/cases.md` before you consider it done.

## Agents

| Agent | Purpose | Status |
|---|---|---|
| `sales-partner` | Interviews a business, then runs a five-stage lead pipeline — prospect, research, approach, sales call, follow-up — over a CRM | Designed, not yet built |

## Specs

- [Portable Agent Specification Format](docs/superpowers/specs/2026-09-01-portable-agent-spec-design.md) — the framework every agent conforms to
- [Sales Partner Agent](docs/superpowers/specs/2026-09-01-sales-partner-agent-design.md) — the first agent
