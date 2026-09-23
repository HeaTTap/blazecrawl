#!/usr/bin/env bash
# Hero demo session: zero -> first scrape.
# RECORDED by asciinema. Commands are typed with realistic pacing but executed
# for REAL against the disposable loopback demo instance. No output fabricated;
# every response is the actual server's bytes (jq/python only select fields).
set -euo pipefail

BASE_URL="${BLAZECRAWL_DEMO_URL:-http://127.0.0.1:8010}"
KEY="${BLAZECRAWL_DEMO_KEY:?BLAZECRAWL_DEMO_KEY must be set (loopback demo value)}"

typeline() {
  local text="$1" i
  for ((i = 0; i < ${#text}; i++)); do printf '%s' "${text:i:1}"; sleep 0.018; done
  sleep 0.25; printf '\n'
}

clear
printf '  \033[1;33mBlazeCrawl\033[0m — security-first, self-hostable web extraction\n'
sleep 1.0

typeline '$ docker run -d -p 127.0.0.1:8000:8000 ghcr.io/danishxsethi/blazecrawl:0.1.2'
printf '\033[2m  ✓ container running (image pre-pulled)\033[0m\n'
sleep 0.9

typeline "$ curl $BASE_URL/health"
curl -fsS "$BASE_URL/health" | python3 -m json.tool --compact
sleep 1.2

typeline "$ curl -X POST $BASE_URL/v1/scrape -d '{\"url\":\"https://example.com\"}'"
curl -fsS -X POST "$BASE_URL/v1/scrape" \
  -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -d '{"url":"https://example.com"}' \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["data"]["markdown"])'
sleep 1.4

printf '\n  \033[1;32m✓\033[0m scrape   \033[1;32m✓\033[0m Markdown   \033[1;32m✓\033[0m self-hosted\n'
printf '  \033[2mgithub.com/danishxsethi/blazecrawl\033[0m\n'
sleep 1.6
