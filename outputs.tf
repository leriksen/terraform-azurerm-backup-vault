output "id" {
  value       = azurerm_data_protection_backup_vault.this.id
  description = "Resource ID of the backup vault."
}

output "name" {
  value       = azurerm_data_protection_backup_vault.this.name
  description = "Name of the backup vault."
}

output "principal_id" {
  value       = length(azurerm_data_protection_backup_vault.this.identity) > 0 ? azurerm_data_protection_backup_vault.this.identity[0].principal_id : null
  description = "Principal ID of the SystemAssigned managed identity, when identity is enabled."
  sensitive   = true
}
