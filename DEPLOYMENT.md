# Azure Static Web Apps Deployment - Quick Start

This guide walks you through deploying your DocFX wiki to Azure Static Web Apps in minutes.

## Prerequisites

- Azure subscription ([free trial available](https://azure.microsoft.com/free/))
- Azure CLI installed ([install guide](https://learn.microsoft.com/cli/azure/install-azure-cli))
- GitHub repository access (for setting secrets)

## Step-by-Step Deployment

### 1. Clone and Customize

```bash
# Clone the repository
git clone https://github.com/YOUR-USERNAME/docfx-wiki.git
cd docfx-wiki

# Edit the parameters file
cd infra
nano bicep.parameters.json  # or use your preferred editor
```

**Edit these values in `bicep.parameters.json`:**

```json
{
  "parameters": {
    "staticWebAppName": {
      "value": "my-unique-wiki-name"  // ⚠️ Must be globally unique
    },
    "location": {
      "value": "eastus2"  // Choose your preferred region
    },
    "sku": {
      "value": "Free"  // Free or Standard
    }
  }
}
```

### 2. Login to Azure

```bash
az login
```

### 3. Deploy Infrastructure (One Command!)

```bash
# Create resource group and deploy in one go
RESOURCE_GROUP="rg-docfx-wiki"
LOCATION="eastus2"

az group create --name $RESOURCE_GROUP --location $LOCATION && \
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file main.bicep \
  --parameters bicep.parameters.json
```

✅ **Success!** Your Azure Static Web App is now created.

### 4. Get Your Deployment Token

```bash
DEPLOYMENT_TOKEN=$(az deployment group show \
  --resource-group $RESOURCE_GROUP \
  --name main \
  --query properties.outputs.deploymentToken.value \
  --output tsv)

echo "Your deployment token: $DEPLOYMENT_TOKEN"
```

⚠️ **Important:** Copy this token - you'll need it in the next step.

### 5. Add Secret to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Set:
   - **Name:** `AZURE_STATIC_WEB_APPS_API_TOKEN`
   - **Value:** Paste the deployment token from step 4
5. Click **Add secret**

### 6. Trigger Deployment

Option A: Push to main branch
```bash
git add .
git commit -m "Update documentation"
git push origin main
```

Option B: Manual trigger
1. Go to **Actions** tab in GitHub
2. Select **Deploy to Azure Static Web Apps**
3. Click **Run workflow**

### 7. View Your Site

Get your site URL:
```bash
az staticwebapp show \
  --name $(jq -r '.parameters.staticWebAppName.value' bicep.parameters.json) \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostname \
  --output tsv
```

Or find it in the Azure Portal:
- Go to [portal.azure.com](https://portal.azure.com)
- Navigate to your resource group
- Click on your Static Web App
- Copy the URL from the Overview page

## What Happens Next?

✨ **Automatic Deployments:** Every time you push changes to the `docs/**` folder on the `main` branch, GitHub Actions will:
1. Build your DocFX site
2. Deploy it to Azure Static Web Apps
3. Make it available at your custom URL

## Troubleshooting

### "Static Web App name already exists"
- Change `staticWebAppName` in `bicep.parameters.json` to a unique value
- Re-run the deployment command

### "Deployment token not working"
- Regenerate the token:
  ```bash
  az staticwebapp secrets list \
    --name YOUR_APP_NAME \
    --resource-group $RESOURCE_GROUP
  ```
- Update the GitHub secret with the new token

### "Workflow not triggering"
- Check that the workflow file exists: `.github/workflows/azure-swa-deploy.yml`
- Verify the secret name is exactly: `AZURE_STATIC_WEB_APPS_API_TOKEN`
- Check workflow runs under the **Actions** tab

### "Site shows 404 or not found"
- Wait 2-3 minutes after first deployment
- Clear your browser cache
- Check the deployment status in GitHub Actions

## Cleanup

To delete all resources and stop charges:

```bash
az group delete --name $RESOURCE_GROUP --yes --no-wait
```

## Next Steps

- 📝 [Edit your wiki content](../docs/content/)
- 🎨 [Customize DocFX templates](../docs/docfx.json)
- 🔧 [Configure routing](../staticwebapp.config.json)
- 📊 [Monitor with Application Insights](https://learn.microsoft.com/azure/static-web-apps/monitor)

## Support

- 📖 [Azure Static Web Apps Documentation](https://learn.microsoft.com/azure/static-web-apps/)
- 💬 [GitHub Discussions](https://github.com/YOUR-USERNAME/docfx-wiki/discussions)
- 🐛 [Report Issues](https://github.com/YOUR-USERNAME/docfx-wiki/issues)
