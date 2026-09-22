# @blazecrawl/sdk

Node.js API client for a running BlazeCrawl Core server. Requires Node.js 18+.

## Install

```bash
npm install @blazecrawl/sdk@0.1.2
```

## Authenticate and scrape

```js
import { BlazeCrawl } from "@blazecrawl/sdk";

const client = new BlazeCrawl({
  apiKey: "blz_local_...",
  baseUrl: "http://127.0.0.1:8000",
});

try {
  const document = await client.scrape("https://example.com");
  console.log(document.markdown);
} catch (error) {
  console.error("BlazeCrawl request failed:", error);
}
```

Use `map()` to discover URLs. `crawl()` starts a job; poll the returned job
reference through the client until completion.
