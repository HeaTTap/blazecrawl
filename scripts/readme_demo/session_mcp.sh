#!/usr/bin/env bash
# MCP / AI-agent demo session. RECORDED by asciinema.
#
# Shows BlazeCrawl acting as the web-extraction layer for an MCP client. This is
# a REAL MCP exchange (initialize -> tools/list -> tools/call scrape) performed
# by a minimal local MCP client harness against a real blazecrawl-mcp server.
# No LLM is involved or implied.
set -euo pipefail

export BLAZECRAWL_API_URL="${BLAZECRAWL_DEMO_URL:-http://127.0.0.1:8010}"
export BLAZECRAWL_API_KEY="${BLAZECRAWL_DEMO_KEY:?set BLAZECRAWL_DEMO_KEY}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLIENT="$HERE/mcp_demo_client.py"

typeline() {
  local text="$1" i
  for ((i = 0; i < ${#text}; i++)); do printf '%s' "${text:i:1}"; sleep 0.018; done
  sleep 0.25; printf '\n'
}

clear
printf '  \033[1;33mMCP\033[0m — give an AI client web-extraction tools, self-hosted\n'
sleep 0.9

printf '  \033[2mAI client → MCP → BlazeCrawl → web\033[0m\n'
sleep 0.6

typeline '$ blazecrawl-mcp   # stdio server; tools: scrape, map, crawl'
printf '\033[2m  (server speaks MCP over stdio; a client connects to it)\033[0m\n'
sleep 0.9

typeline '$ mcp-client: tools/list'
typeline '$ mcp-client: tools/call scrape {"url":"https://example.com"}'
# Real MCP exchange via the local harness.
python3 "$CLIENT" blazecrawl-mcp
sleep 1.4

printf '\n  \033[1;32m✓\033[0m real MCP exchange   \033[1;32m✓\033[0m no third-party scraping service\n'
sleep 1.4
