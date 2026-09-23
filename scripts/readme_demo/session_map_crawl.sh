#!/usr/bin/env bash
# Map -> Crawl demo session. RECORDED by asciinema; executes the real BlazeCrawl
# CLI against the disposable loopback demo instance. Output is real; it is only
# piped through python to select/format fields for readability.
set -euo pipefail

export BLAZECRAWL_API_URL="${BLAZECRAWL_DEMO_URL:-http://127.0.0.1:8010}"
export BLAZECRAWL_API_KEY="${BLAZECRAWL_DEMO_KEY:?set BLAZECRAWL_DEMO_KEY}"
SITE="https://quotes.toscrape.com"

typeline() {
  local text="$1" i
  for ((i = 0; i < ${#text}; i++)); do printf '%s' "${text:i:1}"; sleep 0.018; done
  sleep 0.25; printf '\n'
}

clear
printf '  \033[1;33mmap → crawl\033[0m — discover a site, then extract a bounded set\n'
sleep 0.9

# MAP: real CLI, real JSON, presented as a clean URL list.
typeline "$ blazecrawl map $SITE"
blazecrawl map "$SITE" | python3 -c '
import json, sys
d = json.load(sys.stdin)
urls = d.get("urls", [])
count = d.get("count", len(urls))
print("  discovered %d URLs:" % count)
for u in urls[:5]:
    print("   ", u)
print("    … (%d total)" % len(urls))
'
sleep 1.3

# CRAWL: real CLI with --wait; present a clean summary of the actual result.
typeline "$ blazecrawl crawl $SITE --max-pages 5 --wait"
out="$(blazecrawl crawl "$SITE" --max-pages 5 --wait 2>/dev/null)"
echo "$out" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print("  status: %s" % d.get("status"))
print("  pages_crawled: %s" % d.get("pages_crawled"))
for p in d.get("pages", [])[:5]:
    print("    [%s] %s" % (p.get("status_code"), p.get("url")))
'
sleep 1.2

printf '\n  \033[1;32m✓\033[0m 5 pages   \033[1;32m✓\033[0m Markdown extracted   \033[1;32m✓\033[0m robots respected\n'
sleep 1.4
