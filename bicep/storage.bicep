@description('Name of environment')
param env string = 'sbx'

@description('Default location for all resources.')
param location string = resourceGroup().location

var name = 'bg'

resource datadisk 'Microsoft.Compute/disks@2024-03-02' = {
  name: '${name}-disk-${env}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }

  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 10
    encryptionSettingsCollection: {
      enabled: false
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: '${name}sa${env}${uniqueString(resourceGroup().id, name)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
  }

  properties: {
    supportsHttpsTrafficOnly: false

    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
    }
  }
}
