@description('Virtual Network Name')
param vnetName string = 'aci-vnet-1'

@description('Address prefix of the virtual network')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Subnet prefix where ACI will be deployed')
param subnetAddressPrefix string = '10.0.0.0/24'

@description('Subnet name where ACI will be deployed')
param subnetName string = 'aci-subnet'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Container group name')
param containerGroupName string = 'aci-container-group-runner'

@description('Container name')
param containerName string = 'aci-container-runner'

@description('Port to open on the container.')
param port int = 80

@description('The number of CPU cores to allocate to the container. Must be an integer.')
param cpuCores int = 1

@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 2

@description('URL of the container registry')
param registryURL string

@description('Container image that will be used to create a container')
param image string = '${registryURL}/runner:v1'

@description('Username to login to the ACR')
param userName string

@description('Password to login to ACR')
@secure()
param password string

@description('GTIHUB TOKEN')
@secure()
param gitToken string

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: subnetName
  parent: vnet
  properties: {
    addressPrefix: subnetAddressPrefix
    delegations: [
      {
        name: 'DelegationService'
        properties: {
          serviceName: 'Microsoft.ContainerInstance/containerGroups'
        }
      }
    ]
  }
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: containerGroupName
  location: location
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: image
          environmentVariables: [
            {
              name: 'RUNNER_REPOSITORY_URL'
              value: 'https://github.com/garima2510/self-hosted-runner-azure-containers'
            }
            {
              name: 'GITHUB_TOKEN'
              secureValue: gitToken
            }
          ]
          ports: [
            {
              port: port
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
        }
      }
    ]
    imageRegistryCredentials: [
      {
        server: registryURL
        username: userName
        password: password
      }
    ]
    osType: 'Linux'
    subnetIds: [
      {
        id: subnet.id
      }
    ]
    restartPolicy: 'OnFailure'
  }
}

output containerIPv4Address string = containerGroup.properties.ipAddress.ip
