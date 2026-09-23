# README demo generation

Reproducible tooling for the README's visual product demos. Every demo executes
the **real** BlazeCrawl product against a disposable, loopback-only instance —
no output is fabricated, no credentials are shown, and no external SaaS is used.

## What this produces

| Asset | Flow | File |
|---|---|---|
| Hero | launch → `/health` → scrape a page → Markdown | `docs/assets/blazecrawl-hero.gif` |
| Map → Crawl | `blazecrawl map` → `blazecrawl crawl --wait` | `docs/assets/blazecrawl-map-crawl.gif` |
| Security | egress diagram + real allowed/blocked responses | `docs/assets/blazecrawl-security.gif` |
| MCP | real `tools/list` + `tools/call scrape` over stdio | `docs/assets/blazecrawl-mcp.gif` |

Each GIF also gets a poster PNG (`docs/assets/blazecrawl-<name>.png`) for
fallback/social use.

## Prerequisites

Required tools (all OSS, no proprietary software):

- **Docker** — runs the disposable demo instance.
- **asciinema** — records the terminal session (`pipx install asciinema` or
  `pip install asciinema`).
- **agg** — renders the `.cast` to GIF. Use the static musl build on older glibc:
  <https://github.com/asciinema/agg/releases> (`agg-x86_64-unknown-linux-musl`).
- **gifsicle** — optimizes GIFs (`apt install gifsicle`).
- **ffmpeg** — extracts poster frames (`apt install ffmpeg`).

A Python 3.12 venv providing the `blazecrawl` CLI and `blazecrawl-mcp` server
(used by the map-crawl and mcp demos):

```bash
uv venv --seed --python 3.12 /tmp/blazecrawl-demo-cli
/tmp/blazecrawl-demo-cli/bin/pip install blazecrawl-core==0.1.2 blazecrawl-mcp==0.1.2
```

## Regenerate everything

```bash
export AGG=/path/to/agg-musl
export BLAZECRAWL_CLI_VENV=/tmp/blazecrawl-demo-cli
bash scripts/readme_demo/render.sh     # start instance, record, render raw GIFs
bash scripts/readme_demo/optimize.sh   # optimize into docs/assets/ + poster PNGs
```

`render.sh` starts a disposable container from
`ghcr.io/danishxsethi/blazecrawl:0.1.2` bound to `127.0.0.1:8010` with an
obviously non-secret demo key (`blz_local_readme_demo`), records the four
sessions, and removes the container and its volume afterward.

Approximate generation time: ~2–3 minutes (plus a one-time image pull).

## How it works

- `session_hero.sh`, `session_map_crawl.sh`, `session_security.sh`,
  `session_mcp.sh` are recorded by asciinema. They type commands with realistic
  pacing but **execute them for real**; JSON responses are piped through
  `python3`/`jq` only to select and format fields — the underlying bytes are the
  server's actual output.
- `mcp_demo_client.py` is a minimal, standards-compliant MCP stdio client used
  only to drive a real `initialize → tools/list → tools/call` exchange for the
  MCP demo. No LLM is involved or implied.
- The security demo pairs a labeled architectural **diagram** (resolve →
  validate → pin → connect) with **real** allowed/blocked responses. The diagram
  is not packet-level telemetry.

## Notes / honest limitations

- Commands are executed against a loopback demo instance on `127.0.0.1:8010`; the
  README quickstart uses the default `8000`. The flow is identical.
- The demo key is a placeholder that satisfies the key format; it is loopback-only
  and never a real credential. The visible terminal never shows a key value.
- `quotes.toscrape.com` is used for the map/crawl demo because it is a stable
  public site designed for scraping practice; `example.com` is used for the
  single-page scrape.
