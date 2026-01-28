# DocFX Wiki

A proof of concept (PoC) wiki-style documentation site built with [DocFX](https://github.com/dotnet/docfx). It demonstrates a simple, yet feature-rich wiki experience (navigation, search, static hosting) while keeping authoring lightweight with Markdown.

The focus of this repo is to provide a reusable template so others can quickly start a wiki in their own environment and deploy it with minimal setup.

## Publish

Click the green `Use this template` button in the top right of this page and choose `create a new repository`, then pick one of the following deployment options:

### Option 1: GitHub Pages

- Workflow: `.github/workflows/publish-site.yml`

Enable GitHub Pages for the new repo created from this template:

1. In the repo, go to **Settings** → **Pages**.
2. Under **Build and deployment**, set **Source** to **GitHub Actions**.
3. Deploy to GitHub Pages by pushing a change under `docs/` to `main` or run the workflow via **Actions**.

### Option 2: Azure Static Web Apps

- Workflow: `.github/workflows/azure-swa-deploy.yml`
- Requires a repo secret named `AZURE_STATIC_WEB_APPS_API_TOKEN`

Quick deploy (Codespaces recommended):

1. Edit the `infra/bicep.parameters.json` as desired.
2. Authenticate to Azure using `az login` and select the desired subscription
3. Run the deployment script:
```bash
./deploy-azure.sh
```
4. Copy the deployment token from the Azure Static Web App in the Azure Portal.
5. Create a repo secret in this repository named `AZURE_STATIC_WEB_APPS_API_TOKEN` with the deployment token as the value.
6. Uncomment `.github/workflows/azure-swa-deploy.yml` and run the workflow via **Actions**. 

or

Manual setup: see `DEPLOYMENT.md`.

## Local Development

### Option A: GitHub Codespaces (recommended)

1. Create a Codespace from this repo.
2. Wait for the dev container to finish provisioning.
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

## Learn more

- DocFX project: https://github.com/dotnet/docfx
- Azure Static Web Apps: https://learn.microsoft.com/azure/static-web-apps/