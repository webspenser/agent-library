#!/usr/bin/env python3
"""Checks .claude-plugin/marketplace.json. Prints one FAIL line per problem."""
import json
import pathlib
import re
import sys
import urllib.error
import urllib.request

KEBAB = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
REPO = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
ROOT = pathlib.Path(__file__).resolve().parent.parent


def fetch_plugin_name(repo):
    url = f"https://raw.githubusercontent.com/{repo}/HEAD/.claude-plugin/plugin.json"
    try:
        with urllib.request.urlopen(url, timeout=20) as resp:
            return json.loads(resp.read().decode("utf-8")).get("name"), None
    except urllib.error.HTTPError as err:
        return None, f"{repo}: .claude-plugin/plugin.json not found (HTTP {err.code})"
    except (urllib.error.URLError, TimeoutError) as err:
        return None, f"{repo}: could not fetch plugin.json ({err})"
    except (json.JSONDecodeError, UnicodeDecodeError, AttributeError):
        return None, f"{repo}: .claude-plugin/plugin.json is not a JSON object"


def main():
    fails = []
    path = ROOT / ".claude-plugin" / "marketplace.json"
    try:
        market = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError, UnicodeDecodeError) as err:
        print(f"FAIL: .claude-plugin/marketplace.json unreadable ({err})")
        return 1
    if not isinstance(market, dict):
        print("FAIL: .claude-plugin/marketplace.json must be a JSON object")
        return 1
    if market.get("name") != "webspenser":
        fails.append("marketplace name must be \"webspenser\"")
    if not isinstance(market.get("owner"), dict) or not market["owner"].get("name"):
        fails.append("owner.name is missing")
    plugins = market.get("plugins")
    if not isinstance(plugins, list) or not plugins:
        fails.append("plugins must be a non-empty list")
        plugins = []
    seen = set()
    for i, entry in enumerate(plugins):
        if not isinstance(entry, dict):
            fails.append(f"plugins[{i}] must be an object")
            continue
        name = entry.get("name")
        label = name if isinstance(name, str) and name else f"plugins[{i}]"
        if not isinstance(name, str) or not KEBAB.match(name):
            fails.append(f"{label}: name must be kebab-case")
        elif name in seen:
            fails.append(f"{label}: duplicate name")
        seen.add(name)
        if not isinstance(entry.get("description"), str) or not entry["description"].strip():
            fails.append(f"{label}: description is missing")
        source = entry.get("source")
        if not (isinstance(source, dict) and source.get("source") == "github"
                and isinstance(source.get("repo"), str) and REPO.match(source["repo"])):
            fails.append(f"{label}: source must be {{\"source\": \"github\", \"repo\": \"owner/repo\"}}")
            continue
        remote_name, err = fetch_plugin_name(source["repo"])
        if err:
            fails.append(f"{label}: {err}")
        elif remote_name != name:
            fails.append(f"{label}: {source['repo']} publishes plugin {remote_name!r}, not {name!r}")
    for message in fails:
        print(f"FAIL: {message}")
    if not fails:
        print(f"OK: {len(plugins)} plugin(s) listed")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
