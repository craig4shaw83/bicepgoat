@description('Name of environment')
param env string = 'sbx'

@description('Default location for all resources.')
param location string = resourceGroup().location

@description('Subnet ID for the NIC')
param subnetId string

var name = 'bg'


resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${name}-nic-${env}'
  location: location

  properties: {
    ipConfigurations: [
      {
        name: 'internal'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource linuxVm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: '${name}-linux-${env}'
  location: location

  properties: {
    hardwareProfile: {
      vmSize: 'Standard_F2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04-LTS'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile: {
      computerName: '${name}-linux-${env}'
      adminUsername: 'adminuser'
      adminPassword: 'N0tV3ryS3cur3P@ssw0rd!'
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
  }
}
