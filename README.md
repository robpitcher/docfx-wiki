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

This repository supports two deployment options:

### Option 1: GitHub Pages (Default)

A GitHub Actions workflow automatically builds and deploys `docs/_site` to GitHub Pages on pushes to `main`.

Workflow: `.github/workflows/publish-site.yml`

### Option 2: Azure Static Web Apps

Deploy to Azure Static Web Apps for a production-ready hosting solution with global CDN, custom domains, and automatic SSL certificates.

#### Quick Setup

1. **Deploy Infrastructure**
   ```bash
   # Edit parameters in infra/bicep.parameters.json
   # Then deploy:
   cd infra
   az group create --name rg-docfx-wiki --location eastus2
   az deployment group create \
     --resource-group rg-docfx-wiki \
     --template-file main.bicep \
     --parameters bicep.parameters.json
   ```

2. **Get Deployment Token**
   ```bash
   az deployment group show \
     --resource-group rg-docfx-wiki \
     --name main \
     --query properties.outputs.deploymentToken.value \
     --output tsv
   ```

3. **Add GitHub Secret**
   - Go to repository Settings → Secrets and variables → Actions
   - Create new secret: `AZURE_STATIC_WEB_APPS_API_TOKEN`
   - Paste the deployment token

4. **Enable Workflow**
   
   The workflow `.github/workflows/azure-swa-deploy.yml` will automatically deploy on pushes to `main` when documentation changes.

#### Customization

- **Infrastructure**: Edit `infra/bicep.parameters.json` to customize:
  - `staticWebAppName`: Your unique app name
  - `location`: Azure region
  - `sku`: Free or Standard tier
  - `tags`: Resource organization tags

- **Runtime Configuration**: Edit `staticwebapp.config.json` for:
  - Navigation fallback rules
  - Custom routes
  - Headers and MIME types

See [infra/README.md](infra/README.md) for detailed deployment instructions.

## Learn more

- DocFX project: https://github.com/dotnet/docfx
- Azure Static Web Apps: https://learn.microsoft.com/azure/static-web-apps/