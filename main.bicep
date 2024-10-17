@description('Name of environment')
param env string = 'sbx'

@description('Default location for all resources.')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'bg-vnet-${env}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

module appService 'bicep/app-service.bicep' = {
  name: 'appServiceModule'
  params: {
    env: env
    location: location
  }
}

module storageAccount 'bicep/storage.bicep' = {
  name: 'storageAccountModule'
  params: {
    env: env
    location: location
  }
}

module aks 'bicep/aks.bicep' = {
  name: 'aksModule'
  params: {
    env: env
    location: location
  }
}

module instance 'bicep/instance.bicep' = {
  name: 'instanceModule'
  params: {
    env: env
    location: location
    subnetId: vnet.properties.subnets[0].id
  }
}
