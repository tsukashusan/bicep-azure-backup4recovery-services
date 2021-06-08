//scope
targetScope = 'resourceGroup'
//Storage account for deployment scripts

param existingRecoveryServicesVault string
param existingVirtualMachines array
param existingVirtualMachinesResourceGroup string
param policyId string


module vmbackup 'backup_backupfabrics.bicep' = {
  name: 'backup-backupfabrics'
  params: {
      existingRecoveryServicesVault: existingRecoveryServicesVault
      existingVirtualMachines: existingVirtualMachines
      existingVirtualMachinesResourceGroup: existingVirtualMachinesResourceGroup
      policyId: policyId
    }
}
