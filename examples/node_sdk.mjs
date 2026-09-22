/**
 * Node SDK: scrape, map, and crawl via a running BlazeCrawl Core server.
 *
 * Install the published SDK and run a server (see README Quickstart), then:
 *
 *   npm install @blazecrawl/sdk
 *   export BLAZECRAWL_API_KEY=blz_local_...
 *   node examples/node_sdk.mjs
 */
import { BlazeCrawl } from "@blazecrawl/sdk";

const bc = new BlazeCrawl({ apiKey: process.env.BLAZECRAWL_API_KEY });

// Scrape a single page to Markdown.
const doc = await bc.scrape("https://example.com");
console.log("TITLE:", doc.metadata?.title);
console.log((doc.markdown || "").slice(0, 200));

// Map a site's URLs.
const site = await bc.map("https://example.com");
console.log(`\nmap discovered ${site.count ?? site.urls?.length} URL(s)`);

// Crawl a bounded subset (crawl waits for completion by default).
const job = await bc.crawl("https://example.com", { max_pages: 5, max_depth: 1 });
console.log(`\ncrawl status=${job.status} pages_crawled=${job.pages_crawled}`);
