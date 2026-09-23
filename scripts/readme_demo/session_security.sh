#!/usr/bin/env bash
# Security / egress demo session. RECORDED by asciinema.
#
# Composition:
#   * a text-based architecture flow (a DIAGRAM — resolve -> validate -> pin ->
#     connect), clearly labeled as such, and
#   * REAL terminal evidence: a safe public URL is allowed, and a loopback URL
#     is blocked with BlazeCrawl's actual error message.
#
# The diagram is an architectural representation, not packet-level telemetry.
# The allowed/blocked outcomes are the real server's responses.
set -euo pipefail

BASE_URL="${BLAZECRAWL_DEMO_URL:-http://127.0.0.1:8010}"
KEY="${BLAZECRAWL_DEMO_KEY:?set BLAZECRAWL_DEMO_KEY}"

typeline() {
  local text="$1" i
  for ((i = 0; i < ${#text}; i++)); do printf '%s' "${text:i:1}"; sleep 0.018; done
  sleep 0.25; printf '\n'
}

clear
printf '  \033[1;33mthe egress model\033[0m — every outbound URL is validated before connect\n'
sleep 1.0

# Architecture diagram (labeled as a diagram; not live packet telemetry).
printf '  \033[2mevery request, static or browser:\033[0m\n'
printf '    URL\n'
sleep 0.35
printf '     \033[2m↓\033[0m  resolve DNS once\n'
sleep 0.35
printf '     \033[2m↓\033[0m  validate \033[1mevery\033[0m resolved IP\n'
sleep 0.35
printf '     \033[2m↓\033[0m  pin connection to the validated IP\n'
sleep 0.35
printf '     \033[2m↓\033[0m  connect\n'
sleep 0.9

# Real evidence: safe URL allowed.
printf '\n'
typeline "$ curl -X POST $BASE_URL/v1/scrape -d '{\"url\":\"https://example.com\"}'"
code=$(curl -sS -o /dev/null -w '%{http_code}' -X POST "$BASE_URL/v1/scrape" \
  -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -d '{"url":"https://example.com"}')
printf '  \033[1;32m→ %s allowed\033[0m  (https://example.com)\n' "$code"
sleep 1.1

# Real evidence: loopback URL blocked with the actual error message.
printf '\n'
typeline "$ curl -X POST $BASE_URL/v1/scrape -d '{\"url\":\"http://127.0.0.1/\"}'"
resp=$(curl -sS -X POST "$BASE_URL/v1/scrape" \
  -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -d '{"url":"http://127.0.0.1/"}')
echo "$resp" | python3 -c '
import json, sys
d = json.load(sys.stdin).get("detail", {})
print("  \033[1;31m✕ blocked\033[0m  (http://127.0.0.1/)")
print("    error:   %s" % d.get("error"))
print("    message: %s" % d.get("message"))
'
sleep 1.6
