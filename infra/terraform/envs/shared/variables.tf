variable "location" {
  description = "Azure region."
  type        = string
  default     = "westeurope"
}

variable "acr_name" {
  description = "Globally unique Azure Container Registry name."
  type        = string
}

variable "acr_sku" {
  description = "Azure Container Registry SKU."
  type        = string
  default     = "Basic"
}