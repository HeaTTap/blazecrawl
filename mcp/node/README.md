# @blazecrawl/mcp

MCP server exposing a self-hosted BlazeCrawl Core instance's `scrape`, `map`,
and `crawl` tools over stdio. Requires Node.js 18+.

## Install

```bash
npm install @blazecrawl/mcp@0.1.2
```

## Generic MCP client configuration

```json
{
  "mcpServers": {
    "blazecrawl": {
      "command": "npx",
      "args": ["-y", "@blazecrawl/mcp@0.1.2"],
      "env": {
        "BLAZECRAWL_API_URL": "http://127.0.0.1:8000",
        "BLAZECRAWL_API_KEY": "blz_local_..."
      }
    }
  }
}
```

The server forwards tool calls to BlazeCrawl. Crawl operations return a job
reference; use the crawl-status tool to poll it.
