"""Map a site, then crawl a bounded subset of it.

`map` discovers a site's URL set (sitemap + link graph). `crawl` then walks
pages same-origin, respecting robots.txt, and returns clean Markdown per page.

Run a server first (see README Quickstart), then:

    export BLAZECRAWL_API_KEY=blz_local_...
    python examples/map_then_crawl.py
"""

import os

from blazecrawl import BlazeCrawl

SEED = "https://example.com"

with BlazeCrawl(api_key=os.environ.get("BLAZECRAWL_API_KEY")) as bc:
    site = bc.map(SEED)
    urls = site.get("urls", [])
    print(f"map discovered {site.get('count', len(urls))} URL(s):")
    for u in urls[:10]:
        print("  -", u)

    # crawl() waits for completion by default and returns the finished job.
    job = bc.crawl(SEED, max_pages=5, max_depth=1)
    print(f"\ncrawl status={job['status']} pages_crawled={job['pages_crawled']}")
    for page in job.get("pages", []):
        print(f"  [{page.get('status_code')}] {page.get('url')} — {page.get('title')!r}")
