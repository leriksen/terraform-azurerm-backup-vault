# terraform-azurerm-backup-vault

Terraform module for creating an Azure Data Protection Backup Vault.

## Why ARM template for some settings?

The `azurerm` provider (4.x) does not expose `soft_delete_enabled`, `retention_duration_in_days`, or `cross_region_restore_enabled` on `azurerm_data_protection_backup_vault`. When any of those variables are set (or when `datastore_type = "OperationalStore"` / `redundancy = "ZoneRedundant"` is requested), the module applies a supplementary ARM template deployment to configure those properties.

## Usage

```hcl
module "backup_vault" {
  source  = "app.terraform.io/leif-lab3/terraform-azurerm-backup-vault/azurerm"
  version = "0.1.0"

  name                = "bvault-prod"
  resource_group_name = "rg-backup"
  location            = "australiaeast"

  datastore_type = "VaultStore"
  redundancy     = "LocallyRedundant"

  identity = {
    type = "SystemAssigned"
  }

  soft_delete_enabled        = true
  retention_duration_in_days = 14
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| hashicorp/azurerm | >= 4.0.0, < 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the backup vault | `string` | — | yes |
| resource\_group\_name | Resource group name | `string` | — | yes |
| location | Azure region | `string` | — | yes |
| datastore\_type | Datastore type: `OperationalStore`, `VaultStore`, or `ArchiveStore` | `string` | `"VaultStore"` | no |
| redundancy | Redundancy: `LocallyRedundant`, `GeoRedundant`, or `ZoneRedundant` | `string` | `"LocallyRedundant"` | no |
| identity | Managed identity block (`{ type = "SystemAssigned" }`) | `object` | `null` | no |
| soft\_delete\_enabled | Enable soft delete | `bool` | `true` | no |
| retention\_duration\_in\_days | Soft delete retention (14–180 days) | `number` | `null` | no |
| cross\_region\_restore\_enabled | Enable cross-region restore (requires `GeoRedundant`) | `bool` | `false` | no |
| tags | Tags to apply | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Resource ID of the backup vault |
| name | Name of the backup vault |
| principal\_id | Principal ID of the SystemAssigned managed identity |

## Testing

Tests use HCP Terraform as the backend. From the `tests/` directory:

```bash
terraform init
terraform test
```
