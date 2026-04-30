variable "name" {
  description = "Virtual network name."
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

variable "address_space" {
  description = "VNet address space."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create."
  type = map(object({
    name                              = string
    address_prefix                    = string
    private_endpoint_network_policies = optional(string, null)
  }))
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}