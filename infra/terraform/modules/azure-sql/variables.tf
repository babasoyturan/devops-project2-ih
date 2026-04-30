variable "server_name" {
  description = "Globally unique Azure SQL Server name."
  type        = string
}

variable "database_name" {
  description = "Azure SQL Database name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "administrator_login" {
  description = "SQL administrator username."
  type        = string
}

variable "administrator_login_password" {
  description = "SQL administrator password."
  type        = string
  sensitive   = true
}

variable "database_sku_name" {
  description = "Azure SQL Database SKU."
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

variable "storage_account_type" {
  description = "Storage account type used to store backups for this database."
  type        = string
  default     = "Local"

  validation {
    condition     = contains(["Geo", "GeoZone", "Local", "Zone"], var.storage_account_type)
    error_message = "Storage account type must be one of: Geo, GeoZone, Local, Zone."
  }
}