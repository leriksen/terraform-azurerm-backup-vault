# ── Required ────────────────────────────────────────────────────────────────

variable "name" {
  type        = string
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

# ── Datastore & redundancy ──────────────────────────────────────────────────

variable "datastore_type" {
  type        = string
  default     = "VaultStore"
  description = "Datastore type for the backup vault."

  validation {
    condition     = contains(["OperationalStore", "VaultStore", "ArchiveStore"], var.datastore_type)
    error_message = "datastore_type must be one of: OperationalStore, VaultStore, ArchiveStore."
  }
}

variable "redundancy" {
  type        = string
  default     = "LocallyRedundant"
  description = "Redundancy setting for the backup vault."

  validation {
    condition     = contains(["LocallyRedundant", "GeoRedundant", "ZoneRedundant"], var.redundancy)
    error_message = "redundancy must be one of: LocallyRedundant, GeoRedundant, ZoneRedundant."
  }
}

# ── Identity ────────────────────────────────────────────────────────────────

variable "identity" {
  type = object({
    type = string
  })
  default     = null
  description = "When set, enables a managed identity on the vault. Only SystemAssigned is currently supported."

  validation {
    condition     = var.identity == null || var.identity.type == "SystemAssigned"
    error_message = "identity.type must be SystemAssigned when identity is set."
  }
}

# ── Soft delete & retention ─────────────────────────────────────────────────

variable "soft_delete_enabled" {
  type        = bool
  default     = true
  description = "Enable soft delete."
}

variable "retention_duration_in_days" {
  type        = number
  default     = null
  description = "Soft delete retention duration in days."

  validation {
    condition     = var.retention_duration_in_days == null || (var.retention_duration_in_days >= 14 && var.retention_duration_in_days <= 180)
    error_message = "retention_duration_in_days must be null or between 14 and 180."
  }
}

variable "cross_region_restore_enabled" {
  type        = bool
  default     = false
  description = "Enable cross-region restore."

  validation {
    condition     = var.cross_region_restore_enabled == false || var.redundancy == "GeoRedundant"
    error_message = "cross_region_restore_enabled can only be true when redundancy is GeoRedundant."
  }
}

# ── Tags ────────────────────────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply."
}
