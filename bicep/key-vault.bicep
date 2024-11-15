@description('Name of environment')
param env string = 'sbx'

@description('Default location for all resources.')
param location string = resourceGroup().location

var name = 'bg'

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: '${name}-vault-${env}'
  location: location

  properties: {
    tenantId: subscription().tenantId

    sku: {
      name: 'premium'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2024-04-01-preview' = {
  parent: keyVault
  name: '${name}-secret-${env}'

  properties: {
    value: 'some value'
  }
}
