# Repo Instructions (Template-Friendly)

Purpose: Give Copilot a quick map of this DocFX-based docs repo so it can make accurate edits without scanning everything. These instructions are intentionally generic so the repo can be templated.

## Repository map

- Author content lives in [docs/content](../docs/content).
- Site scaffolding + DocFX config live in [docs](../docs).
- Generated site output lives in [docs/_site](../docs/_site) (do not edit).
- Publishing is handled by GitHub Actions in [.github/workflows](../.github/workflows).
- The site landing/redirect is defined in [docs/index.md](../docs/index.md).
- Project root overview is in [README.md](../README.md).

## Where to edit

Most of the time you should only touch:
- Markdown content pages in [docs/content](../docs/content)
- Navigation in [docs/content/toc.yml](../docs/content/toc.yml)

Avoid editing generated artifacts under [docs/_site](../docs/_site).

## Content conventions

- Use a single H1 (`# Title`) at the top of each page.
- Prefer simple, standard Markdown. DocFX-style callouts are fine when useful (e.g., `> [!NOTE]`, `> [!TIP]`, `> [!IMPORTANT]`).
- For cross-linking between content pages, prefer absolute content links like `/content/<page>.md`.
- Keep headings and section structure consistent within a page; avoid duplicate H1s.

## Adding or moving pages

### Add a new page
1. Create a new `.md` file under [docs/content](../docs/content) (choose a short, URL-safe file name).
2. Add it to [docs/content/toc.yml](../docs/content/toc.yml) under the appropriate section so it appears in navigation.
3. Add at least one link to it from a related page (use `/content/<page>.md`).

### Rename or move a page
- If you rename/move a file in [docs/content](../docs/content), also update:
	- Its entry in [docs/content/toc.yml](../docs/content/toc.yml)
	- Any internal links that reference the old path

## DocFX structure

- DocFX config is in [docs/docfx.json](../docs/docfx.json).
- The build output folder is [docs/_site](../docs/_site) and is generated.
- Templates (if present) live under [docs/template](../docs/template).

## Build and publish

- CI/CD workflow(s) live in [.github/workflows](../.github/workflows).
- Typical authoring changes are just content + toc; CI handles the DocFX build and deployment.
- Local preview (optional): run DocFX from the repo root using something like `docfx docs/docfx.json --serve`.

## What NOT to change

- Do not hand-edit anything under [docs/_site](../docs/_site).
- Do not change the redirect behavior in [docs/index.md](../docs/index.md) unless you intend to change the site landing page.
- Avoid large refactors (renames/moves) unless you also update navigation + links.

## Quick pointers for Copilot

- Default to editing files under [docs/content](../docs/content).
- When adding pages, always update [docs/content/toc.yml](../docs/content/toc.yml).
- Keep changes minimal and consistent with existing page style.

## License

- See [LICENSE](../LICENSE).