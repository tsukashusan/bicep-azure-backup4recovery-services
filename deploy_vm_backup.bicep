//scope
targetScope = 'resourceGroup'
//Storage account for deployment scripts
var location = resourceGroup().location
var resourceGroupName = resourceGroup().name

param existingRecoveryServicesVault string
param existingVirtualMachines array
param policyId string


module vmbackup 'backup_backupfabrics.bicep' = {
  name: 'backup-backupfabrics'
  params: {
      existingRecoveryServicesVault: existingRecoveryServicesVault
      existingVirtualMachines: existingVirtualMachines
      existingVirtualMachinesResourceGroup: resourceGroupName
      policyId: policyId
    }
}
