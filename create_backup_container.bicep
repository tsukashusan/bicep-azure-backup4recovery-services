param recoveryContainerName string
param location string
param policieName string
param storageModelType string //storageModelType: 'GeoRedundant'| 'LocallyRedundant'
param enableCRR bool
param timezone string

resource backup 'Microsoft.RecoveryServices/vaults@2021-01-01' = {
  name: recoveryContainerName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
  }
}

resource backupconfig  'Microsoft.RecoveryServices/vaults/backupstorageconfig@2021-01-01' = {
  name: 'vaultstorageconfig'
  properties: {
    storageModelType: storageModelType
    crossRegionRestoreFlag: enableCRR
  }
  parent: backup
  dependsOn: [
    backup
  ]
}

resource backuppolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-02-01' = {
  name: policieName
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays: 2
    schedulePolicy: {
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '21:00'
      ]
      schedulePolicyType: 'SimpleSchedulePolicy'
    }
    retentionPolicy: {
      dailySchedule: {
        retentionTimes: [
          '21:00'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Days'
        }
      }
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
        ]
        retentionTimes: [
          '21:00'
        ]
        retentionDuration: {
          count: 4
          durationType: 'Weeks'
        }
      }
      retentionPolicyType: 'LongTermRetentionPolicy'
    }
    protectedItemsCount: 0
    timeZone: timezone
  }
  parent: backup
  dependsOn: [
    backup
  ]
}
output policyId string = backuppolicy.id
output recoveryServicesVaultsId string = backup.id
