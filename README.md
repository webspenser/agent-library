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
| `agent-builder` | Build your own agent on the Webspenser Agent Standard — a guided wizard, a template, and a validator | [webspenser/agent-builder](https://github.com/webspenser/agent-builder) | 1.x |
| `sales-partner` | Interviews a business, then runs a five-stage lead pipeline over a CRM | [webspenser/sales-partner](https://github.com/webspenser/sales-partner) | 0.9 — use it in source mode today ("Use this template"); plugin installs become useful at 1.0.0 |

**Gemini CLI** (unverified): install each repo by URL, e.g.
`gemini extensions install https://github.com/webspenser/agent-builder`.
Codex support comes once it is tested.

## Adding a plugin

1. The plugin's repo passes `webspenser/agent-builder/validate@v1`.
2. Open a pull request here adding one entry to
   `.claude-plugin/marketplace.json` (`name`, `description`, and
   `{"source": "github", "repo": "owner/repo"}`) and one row to the
   table above.
3. CI (`tests/check-catalog.py`) confirms the repo publishes a plugin
   with that name.

## License

Apache-2.0.
