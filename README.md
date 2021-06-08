# Bicep sample (Azure Backup)

## Preparation
1. Install az cli  
https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli
1. bicep install
https://github.com/Azure/bicep/blob/main/docs/installing.md#windows-installer
1. Edit parameter File (For Create Container)
- azuredeploy.parameters.dev.json
  - require
    - xxx -> (recoveryContainerName)
    - xxxx -> (policyName) ex.) daily Tokyo Standard Time
    - LocallyRedundant -> Choose LocallyRedundant or GeoRedundant
    - enableCRR ->  true or false
    - timezone -> Your Timezone ex.)
  LocallyRedundant -> =Choose LocallyRedundant or GeoRedundant </br>
  Tokyo Standard Time -> Choose your time zone.
 
```
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "recoveryContainerName": {
      "value": "xxx"
    },
    "policyName": {
      "value": "xxxx"
    },
    "storageModelType": {
      "value": "LocallyRedundant"
    },
    "enableCRR" : {
      "value": true
    },
    "timezone" :{
      "value": "Tokyo Standard Time"
    }
  }
}
```
## Usage(Create Container)
### STEP 1 (PowerShell) ※ recommended
1. Execute PowerShell Prompt
1. Set Parameter(x)

```
set-variable -name TENANT_ID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -option constant
set-variable -name SUBSCRIPTOIN_GUID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -option constant
set-variable -name BICEP_FILE "backup.bicep" -option constant
set-variable -name PARAMETER_FILE "azuredeploy.parameters.dev.json" -option constant

$resourceGroupName = "xxxxx"
$location = "xxxxx"
```

### STEP 1 (cmd.exe) ※ not recommended
1. Execute PowerShell Prompt
1. Set Parameter(x)

```
setlocal
set TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
set SUBSCRIPTOIN_GUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
set BICEP_FILE=backup.bicep
set PARAMETER_FILE=azuredeploy.parameters.dev.json
set resourceGroupName=xxxxx
set location=xxxxx
```

2. Go to STEP2 (Azure CLI or PowerShell)

### STEP 2 (PowerShell) ※ recommended
1. Azure Login
```
Connect-AzAccount -Tenant ${TENANT_ID} -Subscription ${SUBSCRIPTOIN_GUID}
```
2. Create Resource Group  
```
New-AzResourceGroup -Name ${resourceGroupName} -Location ${location} -Verbose
```
3. Create Deployment
```
New-AzResourceGroupDeployment `
  -Name devenvironment `
  -ResourceGroupName ${resourceGroupName} `
  -TemplateFile ${BICEP_FILE} `
  -TemplateParameterFile ${PARAMETER_FILE} `
  -Verbose
```


### STEP 2 (Azure CLI + PowerShell) ※ recommended
1. Azure Login
```
az login -t ${TENANT_ID} --verbose
```
2. Set Subscription
```
az account set --subscription ${SUBSCRIPTOIN_GUID} --verbose
```
3. Create Resource Group  
```
az group create --name ${resourceGroupName} --location ${location} --verbose
```
4. Deployment Create  
```
az deployment group create --resource-group ${resourceGroupName} --template-file ${BICEP_FILE} --parameters ${PARAMETER_FILE} --verbose
```

### STEP 2 (Azure CLI + cmd.exe) ※ not recommended
1. Azure Login
```
az login -t %TENANT_ID% --verbose
```
2. Set Subscription
```
az account set --subscription %SUBSCRIPTOIN_GUID% --verbose
```
3. Create Resource Group  
```
az group create --name %resourceGroupName% --location %location% --verbose
```
4. Deployment Create  
```
az deployment group create --resource-group %resourceGroupName% --template-file %BICEP_FILE% --parameters %PARAMETER_FILE% --verbose
```

## Usage(Set Backup)
### Preparation
- get_recoveryservicepolicy.ps1
  - xxx -> ResourceGroup of Vault.
  - xxxx -> Recovery Service Container Name(Vault)
```
$resourceGroupName = "xxx"
$recoveryServiceName = "xxxx"


$vault = Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $recoveryServiceName
$policies = Get-AzRecoveryServicesBackupProtectionPolicy -VaultId $vault.id

$policies | % { Write-Host $_.Id }
```
```
> .\get_recoveryservicepolicy.ps1
```

- azuredeploy.backup.parameters.dev.json
  - require
  - ${recoveryContainerName} -> Choose the recoveryContainerName described in azuredeploy.parameters.dev.json.
  - xxx -> Name of the virtual machine to be backed up
  - xxxx -> ResourceGroup Name of Virtual Machine.
  - xxxxx -> Describe policyId. Use the ID that you retrieved using `get_recoveryservicepolicy.ps1.` </br>
```
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "existingRecoveryServicesVault": {
            "value": "sampleRecoveryContainer0"
        },
        "existingVirtualMachines": {
            "value": ["xxx"]
        },
        "existingVirtualMachinesResourceGroup" :{
            "value": "xxxx"
        },
        "policyId": {
            "value": "xxxxx"
        }
    }
}
```
### STEP 1 (PowerShell) ※ recommended
1. Execute PowerShell Prompt
1. Set Parameter(x)

```
set-variable -name TENANT_ID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -option constant
set-variable -name SUBSCRIPTOIN_GUID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -option constant
$bicepFile = "deploy_vm_backup.bicep" -option constant
$parameterFile = "azuredeploy.backup.parameters.dev.json"

$resourceGroupName = "xxxxx"
$location = "xxxxx"
```

### STEP 1 (cmd.exe) ※ not recommended
1. Execute PowerShell Prompt
1. Set Parameter(x)

```
setlocal
set TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
set SUBSCRIPTOIN_GUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
set bicepFile=deploy_vm_backup.bicep
set parameterFile=azuredeploy.backup.parameters.dev.json
set resourceGroupName=xxxxx
set location=xxxxx
```

2. Go to STEP2 (Azure CLI or PowerShell)

### STEP 2 (PowerShell) ※ recommended
1. Azure Login
```
Connect-AzAccount -Tenant ${TENANT_ID} -Subscription ${SUBSCRIPTOIN_GUID}
```
2. Create Resource Group  
```
New-AzResourceGroup -Name ${resourceGroupName} -Location ${location} -Verbose
```
3. Create Deployment
```
New-AzResourceGroupDeployment `
  -Name devenvironment `
  -ResourceGroupName ${resourceGroupName} `
  -TemplateFile ${bicepFile} `
  -TemplateParameterFile ${parameterFile} `
  -Verbose
```


### STEP 2 (Azure CLI + PowerShell) ※ recommended
1. Azure Login
```
az login -t ${TENANT_ID} --verbose
```
2. Set Subscription
```
az account set --subscription ${SUBSCRIPTOIN_GUID} --verbose
```
3. Create Resource Group  
```
az group create --name ${resourceGroupName} --location ${location} --verbose
```
4. Deployment Create  
```
az deployment group create --resource-group ${resourceGroupName} --template-file ${BICEP_FILE} --parameters ${PARAMETER_FILE} --verbose
```

### STEP 2 (Azure CLI + cmd.exe) ※ not recommended
1. Azure Login
```
az login -t %TENANT_ID% --verbose
```
2. Set Subscription
```
az account set --subscription %SUBSCRIPTOIN_GUID% --verbose
```
3. Create Resource Group  
```
az group create --name %resourceGroupName% --location %location% --verbose
```
4. Deployment Create  
```
az deployment group create --resource-group %resourceGroupName% --template-file %BICEP_FILE% --parameters %PARAMETER_FILE% --verbose
```



# CONFIDENTIAL 
本リポジトリにあるすべての成果物は情報提供のみを目的としており、本リポジトリにあるすべての成果物に記載されている情報は、状況等の変化により、内容は変更される場合があります。本リポジトリにあるすべての成果物の情報に対して明示的、黙示的または法的な、いかなる保証も行いません。
