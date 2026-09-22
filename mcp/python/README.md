# blazecrawl-mcp (Python)

MCP server exposing a self-hosted BlazeCrawl Core instance's `scrape`, `map`,
and `crawl` tools over stdio.

## Install

```bash
pip install blazecrawl-mcp==0.1.2
```

## Generic MCP client configuration

```json
{
  "mcpServers": {
    "blazecrawl": {
      "command": "blazecrawl-mcp",
      "env": {
        "BLAZECRAWL_API_URL": "http://127.0.0.1:8000",
        "BLAZECRAWL_API_KEY": "blz_local_..."
      }
    }
  }
}
```

The server forwards MCP tool calls to the configured BlazeCrawl API. Crawl
calls return a job reference; use the available crawl-status tool to poll it.
