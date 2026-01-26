# docfx-wiki

Lightweight wiki-style documentation site built with [DocFX](https://github.com/dotnet/docfx). Author content in Markdown, build a static site, and (optionally) publish to GitHub Pages.

## Quick start

### Option A: GitHub Codespaces (recommended)

1. Create a Codespace from this repo.
2. Wait for the dev container to finish provisioning (it installs DocFX).
3. Start the local site server:

```bash
docfx docs/docfx.json --serve
```

### Option B: VS Code Dev Containers

Prereqs: Docker + VS Code with the “Dev Containers” extension.

1. Open the repo in VS Code.
2. Run “Dev Containers: Reopen in Container”.
3. Serve the site:

```bash
docfx docs/docfx.json --serve
```

### Option C: Local install (no container)

If you already have the .NET SDK installed:

```bash
dotnet tool install -g docfx
export PATH="$PATH:$HOME/.dotnet/tools"
docfx docs/docfx.json --serve
```

## Authoring guide

- Edit pages in `docs/content/` (Markdown).
- Update navigation in `docs/content/toc.yml`.
- Don’t edit generated output in `docs/_site/` (it’s produced by DocFX).

### Add a new page

1. Create a new `docs/content/<your-page>.md` with a single `# Title` at the top.
2. Add it to `docs/content/toc.yml` so it appears in the nav.
3. Link to it from another page (prefer `/content/<your-page>.md`).

## Build

Generate the static site:

```bash
docfx docs/docfx.json
```

Output goes to `docs/_site/`.

## Publish

This repo includes a GitHub Actions workflow that builds the site and deploys `docs/_site` to GitHub Pages on pushes to `main`.

## Learn more

- DocFX project: https://github.com/dotnet/docfx