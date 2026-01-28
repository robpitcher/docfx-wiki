# Azure Infrastructure

This directory contains Bicep templates for deploying the DocFX wiki to Azure Static Web Apps.

## Prerequisites

- Azure CLI installed and authenticated
- Azure subscription
- Appropriate permissions to create resources

## Quick Deployment

### 1. Edit Parameters

Edit `bicep.parameters.json` to customize:
- `staticWebAppName`: Globally unique name for your Static Web App
- `location`: Azure region (default: eastus2)
- `sku`: Free or Standard tier
- `tags`: Resource tags for organization

### 2. Create Resource Group

```bash
az group create --name rg-docfx-wiki --location eastus2
```

### 3. Deploy Bicep Template

```bash
az deployment group create \
  --resource-group rg-docfx-wiki \
  --template-file main.bicep \
  --parameters bicep.parameters.json
```

### 4. Get Deployment Token

After deployment, retrieve the deployment token:

```bash
az deployment group show \
  --resource-group rg-docfx-wiki \
  --name main \
  --query properties.outputs.deploymentToken.value \
  --output tsv
```

### 5. Add Secret to GitHub

Add the deployment token as a repository secret:

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `AZURE_STATIC_WEB_APPS_API_TOKEN`
5. Value: Paste the deployment token from step 4
6. Click "Add secret"

## Available Outputs

The deployment provides these outputs:

- `deploymentToken`: Use this for CI/CD authentication
- `defaultHostname`: Your site's URL
- `resourceId`: Azure resource ID for the Static Web App

## One-Line Deployment Script

For convenience, you can use this one-liner to deploy and capture outputs:

```bash
az deployment group create \
  --resource-group rg-docfx-wiki \
  --template-file main.bicep \
  --parameters bicep.parameters.json \
  --query properties.outputs
```

## Updating the Deployment

To update the deployment with new parameters:

```bash
az deployment group create \
  --resource-group rg-docfx-wiki \
  --template-file main.bicep \
  --parameters bicep.parameters.json
```

## Cleanup

To delete all resources:

```bash
az group delete --name rg-docfx-wiki --yes --no-wait
```
