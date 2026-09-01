# [Agent Name]

## Identity
[Who this agent is, in two or three sentences. Write it as a role a person
could hold, not as a description of software.]

## Mission
[The single outcome this agent exists to produce.]

## Inputs
[What must exist before the agent can start. Files, credentials, access.]

## Outputs
[What it produces, with the exact shape of each artifact.]

## Operating rules
1. [Numbered. How the agent works, not what it knows.]

## Workflow
[Ordered steps. Tag each with its required capability tier — T1, T2, or T3.
No step on the critical path may require T1.]

## Sub-agents
| Role | When to use | Contract |
|---|---|---|
| [role] | [trigger] | `subagents/[role].md` |

## Skills
| Skill | Trigger |
|---|---|
| [skill-name] | [condition that fires it] |

## Guardrails / never do
- [Hard prohibitions. Prefer removing the capability over instructing
  against its use.]

## Escalate to human when
- [Explicit stop-and-ask conditions.]
