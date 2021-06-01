param existingRecoveryServicesVault string
param existingVirtualMachinesResourceGroup string
param existingVirtualMachines array
param policyId string
var backupFabric = 'Azure'

resource backupfabrics 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-02-01-preview' = [for existingVirtualMachine in existingVirtualMachines: {
  name: '${existingRecoveryServicesVault}/${backupFabric}/IaasVMContainer;iaasvmcontainerv2;${existingVirtualMachinesResourceGroup};${existingVirtualMachine}/vm;iaasvmcontainerv2;${existingVirtualMachinesResourceGroup};${existingVirtualMachine}'
  properties: {
    // workloadType: 'VM'
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    createMode: 'Default'
    policyId: policyId
    sourceResourceId: resourceId(existingVirtualMachinesResourceGroup, 'Microsoft.Compute/virtualMachines',  existingVirtualMachine)
  }
}]
