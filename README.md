![Webspenser Agent Library — the Claude Code plugin marketplace for every agent built to the Agent Standard](assets/banner.png)

# Webspenser Agent Library

**Ready-made AI agents for small businesses, each one safe to leave
running.**

Every agent here does one repeating job in your business, works inside
the tools you already use, and follows written rules it can't break,
checked on every action. Nothing goes out without your approval, and
your data stays in your own systems.

- **[Sales Partner](https://github.com/webspenser/sales-partner)** —
  fresh, researched leads every week, each with its first touch ready
  for you to approve. It never sends.
- **[Agent Builder](https://github.com/webspenser/agent-builder)** —
  build your own agent to the same standard.

Prefer not to set it up yourself? [Webspenser](https://www.webspenser.com/lp/agent-builder)
offers done-for-you setup and ongoing managed services.

This catalog is a Claude Code plugin marketplace (a paid Claude plan is
required).

## Install

    /plugin marketplace add webspenser/agent-library
    /plugin install agent-builder@webspenser
    /plugin install sales-partner@webspenser

## Plugins

| Plugin | What it does | Repo | Status |
|---|---|---|---|
| `agent-builder` | Build your own agent on the Webspenser Agent Standard — a guided wizard, a template, and a validator | [webspenser/agent-builder](https://github.com/webspenser/agent-builder) | 6.0 — builds Agent Standard 6.0 agents, including tools wrapped in n8n and rules accepted as instruction-only |
| `sales-partner` | Lead generation and personalization: interviews a business, then finds, scores and researches fresh leads and prepares each first touch — a recommended channel with a full draft, plus personalized statements for email, LinkedIn and calls. It never sends; approved leads go to your own CRM automations | [webspenser/sales-partner](https://github.com/webspenser/sales-partner) | 6.0 — install, run `/sales-partner:setup` in an empty folder, bind Attio, Airtable or HubSpot and Gmail (all unattended-safe), or add your own CRM or mailbox with `/sales-partner:add-tool`; scheduled runs via `/sales-partner:schedule` |

**Gemini CLI** (unverified): install each repo by URL, e.g.
`gemini extensions install https://github.com/webspenser/agent-builder`.
Codex support comes once it is tested.

## Adding a plugin

1. Agents pass `webspenser/agent-builder/validate@main`; tools (like
   `agent-builder` itself) pass their own tests.
2. Open a pull request here adding one entry to
   `.claude-plugin/marketplace.json` (`name`, `description`, and
   `{"source": "github", "repo": "owner/repo"}`) and one row to the
   table above.
3. CI (`tests/check-catalog.py`) confirms the repo publishes a plugin
   with that name.
4. Agents set `catalog: webspenser` and
   `catalog_repo: webspenser/agent-library` in `agent.yaml` so `setup`
   can enable them in the user's folder. Agents that declare scheduled
   activities must set both.

## License

Apache-2.0.

The weekly check pauses if the repo has no activity for 60 days
(GitHub's rule); re-enable it from the Actions tab.
