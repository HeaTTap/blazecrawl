# Governance

BlazeCrawl Core is currently a **maintainer-led** project. It is young; we keep
governance lightweight and evolve it as the contributor base grows.

## Roles

* **Maintainers** — own the roadmap, review and merge PRs, cut releases, and
  hold the final say on contentious decisions. Listed in this file and via
  repository permissions.
* **Contributors** — anyone who opens issues, PRs, docs, or examples.
* **Committers** (future) — contributors with a sustained track record who are
  granted merge rights by the maintainers.

## Decision process

* Routine changes: lazy consensus — a maintainer merges after review.
* Significant changes (API surface, security model, license, roadmap
  direction): discussed in a GitHub issue/Discussion first; a maintainer
  summarizes and decides, documenting the rationale.
* Security fixes: handled privately per SECURITY.md, then disclosed.

## Triage

* Maintainers aim to acknowledge new issues/PRs within **72 hours**.
* Bugs are prioritized over features; security over everything.
* Reproducible bugs get a minimal-reproduction confirmation and an accurate
  label; we ask for a minimal repro rather than guessing.
* PRs get a timely review where practical. Rejected changes come with an
  explanation, and first-time contributors get help getting a PR over the line.
* Security reports are handled privately per SECURITY.md and not disclosed
  publicly before remediation.

## Release cadence

We do not commit to fixed-date releases. Quality over version churn:

* **Patch** (`v0.1.x` → `v0.1.y`): when real fixes accumulate.
* **Minor** (`v0.1` → `v0.2`): when meaningful backward-compatible
  functionality lands.
* **Major**: only for breaking contract changes.

Releases follow the tag-gated, OIDC-based workflow in `.github/workflows/release.yml`.

## Becoming a contributor/committer

Start with the good-first-issue backlog
([docs/CONTRIBUTION_BACKLOG.md](docs/CONTRIBUTION_BACKLOG.md)). Consistent,
high-quality contributions are the path to commit rights.

## Evolution

If the project gains multiple active organizations, we will adopt a more formal
model (e.g. a small steering committee and documented RFC process).
