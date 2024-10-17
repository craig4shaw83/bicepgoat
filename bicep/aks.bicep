@description('Name of environment')
param env string = 'sbx'

@description('Default location for all resources')
param location string = resourceGroup().location

var name = 'bg'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-07-01' = {
  name: '${name}-aks-${env}'
  location: location

  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.28'
    dnsPrefix: '${name}-${env}'
    enableRBAC: false

    agentPoolProfiles: [
      {
        name: 'default'
        count: 2
        vmSize: 'Standard_D2_v2'
        mode: 'System'
      }
    ]
    addonProfiles: {
      omsagent: {
        enabled: false
      }
    }
  }
}
