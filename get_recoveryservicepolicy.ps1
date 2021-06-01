$resourceGroupName = "bicepsample0427-2"
$recoveryServiceName = "sampleRecoveryContainer0"


$vault = Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroupName -Name $recoveryServiceName
$policies = Get-AzRecoveryServicesBackupProtectionPolicy -VaultId $vault.id

$policies | % { Write-Host $_.Id }