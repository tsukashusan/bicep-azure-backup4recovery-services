//scope
targetScope = 'resourceGroup'
//Storage account for deployment scripts
var location = resourceGroup().location
param policyName string
param recoveryContainerName string
param timezone string


module container 'create_backup_container.bicep' = {
  name: 'create_backup_container'
  params: {
    location: location
    policieName: policyName
    recoveryContainerName: recoveryContainerName
    timezone: timezone
  }
}



