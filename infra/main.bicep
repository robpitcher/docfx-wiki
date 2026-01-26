@description('Name of the Azure Static Web App')
param staticWebAppName string

@description('Location for the Static Web App')
param location string = resourceGroup().location

@description('SKU for the Static Web App')
@allowed([
  'Free'
  'Standard'
])
param sku string = 'Free'

@description('Tags to apply to resources')
param tags object = {}

resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
  }
  properties: {
    repositoryUrl: ''
    branch: ''
    buildProperties: {
      appLocation: '/'
      apiLocation: ''
      outputLocation: 'docs/_site'
    }
  }
}

@description('Deployment token for CI/CD')
output deploymentToken string = staticWebApp.listSecrets().properties.apiKey

@description('Static Web App default hostname')
output defaultHostname string = staticWebApp.properties.defaultHostname

@description('Static Web App resource ID')
output resourceId string = staticWebApp.id
