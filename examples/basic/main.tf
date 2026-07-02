provider "azurerm" {
  features {}
}

module "backup_vault" {
  source = "../.."

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  datastore_type               = var.datastore_type
  redundancy                   = var.redundancy
  identity                     = var.identity
  soft_delete_enabled          = var.soft_delete_enabled
  retention_duration_in_days   = var.retention_duration_in_days
  cross_region_restore_enabled = var.cross_region_restore_enabled
  tags                         = var.tags
}
