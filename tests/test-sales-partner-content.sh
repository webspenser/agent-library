#!/usr/bin/env bash
# Content checks for sales-partner: keys and rules that must stay consistent
# across files. Each block pins one change from the 2026-09-24 spec.
set -uo pipefail
cd "$(dirname "$0")/.."
source tests/lib.sh
SP=sales-partner

echo "-- schedules"
assert_contains "$SP/context/operating-config.md" 'timezone:'
assert_contains "$SP/context/operating-config.md" 'schedules:'
assert_contains "$SP/context/operating-config.md" '- activity: prospect'
assert_contains "$SP/context/operating-config.md" '- activity: digest'
assert_contains "$SP/context/operating-config.md" '## Running on a schedule'
assert_contains "$SP/skills/send-digest/SKILL.md" '`digest` entry in `schedules`'
assert_contains "$SP/skills/interview-business/SKILL.md" '`schedules`'
assert_contains "$SP/AGENT.md" 'Scheduled activities'
while IFS= read -r f; do
  assert_not_contains "$f" 'digest_schedule'
done < <(find "$SP" -name '*.md')

echo "-- prospecting sources"
assert_contains "$SP/context/operating-config.md" 'prospecting_sources: [apify_google_maps, apify_site_scraper, web_search]'
assert_contains "$SP/context/operating-config.md" '**`prospecting_sources`**'
assert_contains "$SP/subagents/prospector.md" 'only the sources listed in `prospecting_sources`'
assert_contains "$SP/subagents/prospector.md" '`apollo` is listed'
assert_contains "$SP/skills/interview-business/SKILL.md" '`prospecting_sources`'

finish
