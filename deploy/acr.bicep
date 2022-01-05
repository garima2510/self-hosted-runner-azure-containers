@minLength(5)
@maxLength(50)
@description('Provide a globally unique name for Azure Container Registry ACR')
param acrName string = 'acregistryrunner'

@description('Provdide a location of the ACR')
param location string = resourceGroup().location

@description('Provde a tier of ACR')
param acrSKU string = 'Basic'

resource acrResource 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: acrName
  location: location
  sku: {
    name: acrSKU
  }
  properties: {
    adminUserEnabled: true
  }
}

@description('Output the login server property')
output loginServer string = acrResource.properties.loginServer
