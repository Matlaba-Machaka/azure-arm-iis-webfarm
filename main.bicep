@description('Deployment Region')
param location string = 'southafricanorth'

@description('VM Administrator Username')
param adminUsername string = 'azureadmin'

@secure()
@description('VM Administrator Password')
param adminPassword string

@description('Allowed RDP Source IP in CIDR Format')
param allowedRdpSourceIp string

var vnetName = 'vnet-dev-san-01'
var subnetName = 'snet-web-01'
var nsgName = 'nsg-web-01'
var availabilitySetName = 'avset-web-01'
var vmSize = 'Standard_B2s'
var vmCount = 2

var storageAccountName = 'st${uniqueString(resourceGroup().id)}'

var githubScriptUri = 'https://raw.githubusercontent.com/Matlaba-Machaka/azure-arm-iis-webfarm/main/setup-iis.ps1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: nsgName
  location: location

  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: allowedRdpSourceIp
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-HTTP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-HTTPS'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }

    subnets: [
      {
        name: subnetName

        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2024-11-01' = {
  name: availabilitySetName
  location: location

  sku: {
    name: 'Aligned'
  }

  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
  }
}

resource publicIps 'Microsoft.Network/publicIPAddresses@2024-10-01' = [for i in range(0, vmCount): {
  name: 'pip-web-${i + 1}'
  location: location

  sku: {
    name: 'Standard'
  }

  properties: {
    publicIPAllocationMethod: 'Static'
  }
}]

resource nics 'Microsoft.Network/networkInterfaces@2024-10-01' = [for i in range(0, vmCount): {
  name: 'nic-web-${i + 1}'
  location: location

  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'

        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: i == 0 ? '10.0.0.4' : '10.0.0.5'

          subnet: {
            id: resourceId(
              'Microsoft.Network/virtualNetworks/subnets',
              vnetName,
              subnetName
            )
          }

          publicIPAddress: {
            id: publicIps[i].id
          }
        }
      }
    ]
  }
}]

resource vms 'Microsoft.Compute/virtualMachines@2024-03-01' = [for i in range(0, vmCount): {
  name: 'vm-web-${i + 1}'
  location: location

  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }

    availabilitySet: {
      id: availabilitySet.id
    }

    osProfile: {
      computerName: 'vm-web-${i + 1}'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }

    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }

      osDisk: {
        createOption: 'FromImage'

        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: nics[i].id
        }
      ]
    }

    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}]

resource customScript 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = [for i in range(0, vmCount): {
  name: '${vms[i].name}/CustomScriptExtension'
  location: location

  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'

    autoUpgradeMinorVersion: true

    settings: {
      fileUris: [
        githubScriptUri
      ]
    }

    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Bypass -File setup-iis.ps1'
    }
  }
}]
