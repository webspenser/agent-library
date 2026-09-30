# Webspenser Agent Library

The catalog of AI agents and tools Webspenser publishes, as a Claude
Code plugin marketplace.

## Install

    /plugin marketplace add webspenser/agent-library
    /plugin install agent-builder@webspenser
    /plugin install sales-partner@webspenser

## Plugins

| Plugin | What it does | Repo | Status |
|---|---|---|---|
| `agent-builder` | Build your own agent on the Webspenser Agent Standard — a guided wizard, a template, and a validator | [webspenser/agent-builder](https://github.com/webspenser/agent-builder) | 3.0 — builds Agent Standard 3.0 agents |
| `sales-partner` | Interviews a business, then runs a five-stage lead pipeline over a CRM | [webspenser/sales-partner](https://github.com/webspenser/sales-partner) | 3.0 — install, run `/sales-partner:setup` in an empty folder, bind Attio or Airtable and Gmail (all unattended-safe), or add your own CRM or mailbox with `/sales-partner:add-tool`; scheduled runs via `/sales-partner:schedule` |

**Gemini CLI** (unverified): install each repo by URL, e.g.
`gemini extensions install https://github.com/webspenser/agent-builder`.
Codex support comes once it is tested.

## Adding a plugin

1. Agents pass `webspenser/agent-builder/validate@v3`; tools (like
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
