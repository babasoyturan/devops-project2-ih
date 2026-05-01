variable "name" {
  description = "Public IP name."
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

variable "allocation_method" {
  description = "Public IP allocation method."
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "Public IP SKU."
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}