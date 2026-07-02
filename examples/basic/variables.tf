variable "name" {
  type        = string
  default     = "bvault-example-dev"
  description = "Name of the backup vault."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "datastore_type" {
  type        = string
  default     = "VaultStore"
  description = "Datastore type for the backup vault."
}

variable "redundancy" {
  type        = string
  default     = "LocallyRedundant"
  description = "Redundancy setting for the backup vault."
}

variable "identity" {
  type = object({
    type = string
  })
  default     = null
  description = "Managed identity configuration for the backup vault."
}

variable "soft_delete_enabled" {
  type        = bool
  default     = true
  description = "Enable soft delete."
}

variable "retention_duration_in_days" {
  type        = number
  default     = null
  description = "Soft delete retention duration in days."
}

variable "cross_region_restore_enabled" {
  type        = bool
  default     = false
  description = "Enable cross-region restore."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply."
}
