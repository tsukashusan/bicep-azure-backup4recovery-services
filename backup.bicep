//scope
targetScope = 'resourceGroup'
//Storage account for deployment scripts
var location = resourceGroup().location
param recoveryContainerName string
param policyName string
param storageModelType string //storageModelType: 'GeoRedundant'| 'LocallyRedundant'
param enableCRR bool
param timezone string


module container 'create_backup_container.bicep' = {
  name: 'create_backup_container'
  params: {
    location: location
    recoveryContainerName: recoveryContainerName
    policieName: policyName
    storageModelType: storageModelType
    enableCRR: enableCRR
    timezone: timezone
  }
}
