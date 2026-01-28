#!/bin/bash

# Azure Static Web Apps Deployment Script
# This script automates the deployment of the DocFX wiki to Azure Static Web Apps

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "\n${GREEN}==>${NC} $1"
}

# Check prerequisites
print_step "Checking prerequisites..."

if ! command -v az &> /dev/null; then
    print_error "Azure CLI is not installed. Please install it from: https://learn.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    print_warning "jq is not installed. Some features may not work. Install with: apt-get install jq"
fi

# Check if logged in to Azure
print_step "Checking Azure login status..."
if ! az account show &> /dev/null; then
    print_info "Not logged in to Azure. Logging in..."
    az login
else
    ACCOUNT=$(az account show --query name -o tsv)
    print_info "Already logged in to Azure account: $ACCOUNT"
fi

# Change to infra directory
cd "$(dirname "$0")/infra"

# Read parameters from bicep.parameters.json
if [ -f "bicep.parameters.json" ]; then
    if command -v jq &> /dev/null; then
        APP_NAME=$(jq -r '.parameters.staticWebAppName.value' bicep.parameters.json)
        LOCATION=$(jq -r '.parameters.location.value' bicep.parameters.json)
        print_info "Using Static Web App name: $APP_NAME"
        print_info "Using location: $LOCATION"
    else
        print_warning "Cannot read parameters without jq. Using defaults."
        APP_NAME="docfx-wiki-swa"
        LOCATION="eastus2"
    fi
else
    print_error "bicep.parameters.json not found!"
    exit 1
fi

# Set resource group name
RESOURCE_GROUP="rg-docfx-wiki"

# Confirm deployment
print_step "Deployment Summary"
echo "Resource Group: $RESOURCE_GROUP"
echo "Static Web App Name: $APP_NAME"
echo "Location: $LOCATION"
echo ""
read -p "Do you want to proceed with deployment? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Deployment cancelled."
    exit 0
fi

# Create resource group
print_step "Creating resource group..."
if az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none; then
    print_info "Resource group created or already exists: $RESOURCE_GROUP"
else
    print_error "Failed to create resource group"
    exit 1
fi

# Deploy Bicep template
print_step "Deploying Azure Static Web App..."
if az deployment group create \
    --resource-group "$RESOURCE_GROUP" \
    --template-file main.bicep \
    --parameters bicep.parameters.json \
    --output none; then
    print_info "Deployment successful!"
else
    print_error "Deployment failed"
    exit 1
fi

# Get deployment token
print_step "Retrieving deployment token..."
DEPLOYMENT_TOKEN=$(az deployment group show \
    --resource-group "$RESOURCE_GROUP" \
    --name main \
    --query properties.outputs.deploymentToken.value \
    --output tsv)

if [ -z "$DEPLOYMENT_TOKEN" ]; then
    print_error "Failed to retrieve deployment token"
    exit 1
fi

# Get site URL
SITE_URL=$(az deployment group show \
    --resource-group "$RESOURCE_GROUP" \
    --name main \
    --query properties.outputs.defaultHostname.value \
    --output tsv)

# Print success message
print_step "Deployment Complete! 🎉"
echo ""
echo "┌────────────────────────────────────────────────────────────────┐"
echo "│                    DEPLOYMENT SUCCESSFUL                       │"
echo "└────────────────────────────────────────────────────────────────┘"
echo ""
echo "Your site will be available at: https://$SITE_URL"
echo ""
echo "Next steps:"
echo ""
echo "1. Add the deployment token to GitHub:"
echo "   - Go to: https://github.com/YOUR-USERNAME/YOUR-REPO/settings/secrets/actions"
echo "   - Create new secret: AZURE_STATIC_WEB_APPS_API_TOKEN"
echo "   - Value (copy this): "
echo ""
echo "   $DEPLOYMENT_TOKEN"
echo ""
echo "2. Push changes to trigger deployment:"
echo "   git add ."
echo "   git commit -m 'Update documentation'"
echo "   git push origin main"
echo ""
echo "3. Monitor deployment:"
echo "   - GitHub Actions: https://github.com/YOUR-USERNAME/YOUR-REPO/actions"
echo "   - Azure Portal: https://portal.azure.com"
echo ""

# Optionally copy token to clipboard if available
if command -v xclip &> /dev/null; then
    echo "$DEPLOYMENT_TOKEN" | xclip -selection clipboard
    print_info "Deployment token copied to clipboard!"
elif command -v pbcopy &> /dev/null; then
    echo "$DEPLOYMENT_TOKEN" | pbcopy
    print_info "Deployment token copied to clipboard!"
fi
