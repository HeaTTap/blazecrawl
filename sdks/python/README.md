# blazecrawl (Python SDK)

Python API client for a running BlazeCrawl Core server.

## Install

```bash
pip install blazecrawl==0.1.2
```

The server is separate. Run `blazecrawl-core` locally or point the client at a
self-hosted instance with `base_url`.

## Authenticate and scrape

```python
from blazecrawl import BlazeCrawl, BlazeCrawlError

try:
    with BlazeCrawl(
        api_key="blz_local_...",
        base_url="http://127.0.0.1:8000",
    ) as client:
        document = client.scrape("https://example.com")
        print(document["markdown"])
except BlazeCrawlError as exc:
    print(f"BlazeCrawl request failed: {exc}")
```

`map()` discovers site URLs. `crawl()` starts a crawl and returns its job
reference; poll that job through the client API until it completes.
