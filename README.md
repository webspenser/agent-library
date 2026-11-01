![Webspenser Agent Library — the Claude Code plugin marketplace for every agent built to the Agent Standard](assets/banner.png)

# Webspenser Agent Library

**Ready-made AI agents for small businesses, each one safe to leave
running.**

Every agent here does one repeating job in your business, works inside
the tools you already use, and follows written rules it can't break,
checked on every action. Nothing goes out without your approval, and
your data stays in your own systems.

- **[Sales Partner](https://github.com/webspenser/sales-partner)** —
  fresh, researched leads every week, each matched to the offer most
  likely to land, with sourced talking points for your own outreach.
  It never sends.
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
| `agent-builder` | Build your own agent on the Webspenser Agent Standard — a guided wizard, a template, and a validator | [webspenser/agent-builder](https://github.com/webspenser/agent-builder) | 7.4 — builds Agent Standard 7.4 agents. Guard policies support allowlists, size limits, values pinned from pushed bindings, fixed values and URL rules. Agents also get owner-only notifications and an activity ledger. A scheduled activity can use optional tools, which run only when the business has connected them, and a scheduled run stops with a clear message when the cloud environment is running a different agent version than the business expects |
| `sales-partner` | Lead generation and offer matching: interviews a business, builds its offer catalog, then finds, scores and researches fresh leads. Research uses Google Maps, reviews, ads, job listings, the website and web search, and finds each lead's owner or decision-maker; a name found only in a business directory is never marked verified. Each lead is matched to the offer most likely to land, with a reason, an evidence rating and sourced talking points. It never sends; you approve each lead, and your own sequences do the outreach | [webspenser/sales-partner](https://github.com/webspenser/sales-partner) | 8.2 — install and run `/sales-partner:setup` in an empty folder. Bind Attio or HubSpot (CRM), Resend (owner notifications), Airtable (activity ledger) and Apify (scraping, capped per lead and per week). Optionally bind Exa (web search, one search per lead to find its decision-maker). Or add your own tool with `/sales-partner:add-tool`. Scheduled runs use `/sales-partner:schedule` |

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
