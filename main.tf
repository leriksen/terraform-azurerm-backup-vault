locals {
  provider_datastore_type = var.datastore_type == "OperationalStore" ? "SnapshotStore" : var.datastore_type
  provider_redundancy     = var.redundancy == "ZoneRedundant" ? "LocallyRedundant" : var.redundancy
  requires_patch = (
    var.datastore_type == "OperationalStore" ||
    var.redundancy == "ZoneRedundant" ||
    var.soft_delete_enabled == false ||
    var.retention_duration_in_days != null ||
    var.cross_region_restore_enabled
  )
}

resource "azurerm_data_protection_backup_vault" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  datastore_type = local.provider_datastore_type
  redundancy     = local.provider_redundancy

  tags = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type = identity.value.type
    }
  }

  lifecycle {
    ignore_changes = [
      datastore_type,
      redundancy,
    ]
  }
}

resource "azurerm_resource_group_template_deployment" "settings" {
  count = local.requires_patch ? 1 : 0

  name                = "${var.name}-settings"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_content = jsonencode({
    "$schema"      = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    contentVersion = "1.0.0.0"
    resources = [
      {
        type       = "Microsoft.DataProtection/backupVaults"
        apiVersion = "2024-04-01"
        name       = var.name
        location   = var.location
        identity = {
          type = var.identity != null ? var.identity.type : "None"
        }
        tags = var.tags
        properties = merge(
          {
            storageSettings = [
              {
                datastoreType = var.datastore_type
                type          = var.redundancy
              }
            ]
          },
          var.cross_region_restore_enabled ? {
            featureSettings = {
              crossRegionRestoreSettings = {
                state = "Enabled"
              }
            }
          } : {},
          var.soft_delete_enabled == false ? {
            securitySettings = {
              softDeleteSettings = {
                state                   = "Off"
                retentionDurationInDays = 0
              }
            }
            } : var.retention_duration_in_days != null ? {
            securitySettings = {
              softDeleteSettings = {
                state                   = "On"
                retentionDurationInDays = var.retention_duration_in_days
              }
            }
          } : {}
        )
      }
    ]
  })

  depends_on = [azurerm_data_protection_backup_vault.this]
}
