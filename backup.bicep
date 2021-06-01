//scope
targetScope = 'resourceGroup'
//Storage account for deployment scripts
var location = resourceGroup().location
param policyName string
param backupconfigName string
param recoveryContainerName string
param storageModelType string 
param timezone string


module container 'create_backup_container.bicep' = {
  name: 'create_backup_container'
  params: {
    backupconfigName: backupconfigName
    location: location
    policieName: policyName
    recoveryContainerName: recoveryContainerName
    storageModelType: storageModelType
    timezone: timezone
  }
}

