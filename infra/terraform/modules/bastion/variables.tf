variable "name" {
  description = "Azure Bastion host name."
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

variable "sku" {
  description = "Azure Bastion SKU."
  type        = string
  default     = "Basic"
}

variable "subnet_id" {
  description = "AzureBastionSubnet ID."
  type        = string
}

variable "public_ip_address_id" {
  description = "Public IP ID for Azure Bastion."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}