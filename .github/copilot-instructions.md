# Repo Instructions (Minimal)

Purpose: Give Copilot a quick map of this repo so it can suggest accurate edits without scanning everything. Emphasis is on the docs/content authoring location.

## Overview

- Primary docs live in [docs/content](../docs/content).
- Site scaffolding and DocFX config live in [docs](../docs).
- Generated site output lives in [docs/_site](../docs/_site) (do not edit).
- Publishing is handled by GitHub Actions in [.github/workflows/publish-site.yml](workflows/publish-site.yml).
- Entry redirect is defined in [docs/index.md](../docs/index.md).
- Top-level readme is [README.md](../README.md).

## Authoring Location: docs/content

Write and edit Markdown pages in [docs/content](../docs/content). Examples:
- [docs/content/introduction.md](../docs/content/introduction.md)
- [docs/content/getting-started.md](../docs/content/getting-started.md)
- [docs/content/navigation.md](../docs/content/navigation.md)
- [docs/content/gear.md](../docs/content/gear.md)
- [docs/content/biking.md](../docs/content/biking.md)
- [docs/content/trekking.md](../docs/content/trekking.md)
- [docs/content/paddling.md](../docs/content/paddling.md)
- [docs/content/team-dynamics.md](../docs/content/team-dynamics.md)
- [docs/content/transition-areas.md](../docs/content/transition-areas.md)
- [docs/content/race-formats.md](../docs/content/race-formats.md)

Navigation menu is controlled by [docs/content/toc.yml](../docs/content/toc.yml).

### Content conventions

- Each page uses a single H1 as the page title.
- Use absolute content links like `/content/<file>.md` inside pages for cross-linking (examples are already present across pages).
- Keep callouts simple; standard Markdown works. Existing pages may use DocFX-style notes (e.g., `> [!IMPORTANT]`) where helpful.
- Avoid editing anything under [docs/_site](../docs/_site); that folder is generated.

### Adding a new page

1. Create `new-topic.md` under [docs/content](../docs/content).
2. Add it to [docs/content/toc.yml](../docs/content/toc.yml) under the appropriate section.
3. Cross-link from related pages using `/content/new-topic.md`.

### Updating navigation

- Edit [docs/content/toc.yml](../docs/content/toc.yml) to add, remove, or reorder pages.
- Keep names concise; hrefs must match file names in [docs/content](../docs/content).

## DocFX and site structure

- DocFX config lives in [docs/docfx.json](../docs/docfx.json).
- The site entry point redirects to the intro via [docs/index.md](../docs/index.md).
- Generated artifacts (HTML, JSON, xref) are placed under [docs/_site](../docs/_site).

## Build and publish

- CI/CD is defined in [.github/workflows/publish-site.yml](workflows/publish-site.yml).
- Commit content changes in [docs/content](../docs/content) and navigation changes in [docs/content/toc.yml](../docs/content/toc.yml); Action handles publish.
- Local preview (optional): Use DocFX if available to build from [docs](../docs). Otherwise rely on CI.

## What NOT to change

- Do not hand-edit files in [docs/_site](../docs/_site).
- Do not move or rename core content without updating [docs/content/toc.yml](../docs/content/toc.yml) and internal links.
- Keep [docs/index.md](../docs/index.md) redirect intact unless changing the site’s landing behavior.

## Quick pointers for Copilot

- Prefer editing files under [docs/content](../docs/content).
- When asked to add topics, generate a new `.md` under [docs/content](../docs/content) and update [docs/content/toc.yml](../docs/content/toc.yml).
- Use existing link patterns and section headings from the current pages.
- Reference related guides with absolute content links (e.g., `/content/navigation.md`, `/content/gear.md`).

## License

- Project is MIT-licensed: see [LICENSE](../LICENSE).