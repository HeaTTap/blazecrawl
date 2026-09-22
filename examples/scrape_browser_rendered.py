"""Scrape a JS-rendered page using the browser path.

BlazeCrawl's `render="auto"` (the default) uses a fast static fetch and falls
back to a Playwright browser when the static result looks thin. You can force
the browser with `render="browser"`.

Run a server first (see README Quickstart), then:

    export BLAZECRAWL_API_KEY=blz_local_...
    python examples/scrape_browser_rendered.py
"""

import os

from blazecrawl import BlazeCrawl

# A page whose meaningful content is injected by JavaScript.
URL = "https://quotes.toscrape.com/js/"

with BlazeCrawl(api_key=os.environ.get("BLAZECRAWL_API_KEY")) as bc:
    # render="browser" forces the Playwright path so JS-injected content appears.
    doc = bc.scrape(URL, render="browser")
    print("TITLE:", doc["metadata"].get("title"))
    print("STATUS:", doc.get("status_code"))
    print("--- Markdown (first 400 chars) ---")
    print((doc.get("markdown") or "")[:400])
