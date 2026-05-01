variable "name" {
  description = "Private Endpoint name."
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

variable "subnet_id" {
  description = "Subnet ID where the private endpoint will be created."
  type        = string
}

variable "private_service_connection_name" {
  description = "Private service connection name."
  type        = string
}

variable "private_connection_resource_id" {
  description = "Target Azure resource ID for the private endpoint."
  type        = string
}

variable "subresource_names" {
  description = "Target subresource names."
  type        = list(string)
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs associated with this private endpoint."
  type        = list(string)
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}