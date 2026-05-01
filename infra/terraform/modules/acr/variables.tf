variable "name" {
  description = "Name of the Azure Container Registry. Must be globally unique."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the ACR will be created."
  type        = string
}

variable "location" {
  description = "Azure region for the ACR."
  type        = string
}

variable "sku" {
  description = "ACR SKU."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Whether the ACR admin user is enabled."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags applied to the ACR."
  type        = map(string)
  default     = {}
}