variable "location" {
  description = "Azure region."
  type        = string
  default     = "westeurope"
}

variable "admin_username" {
  description = "Admin username for Linux VMs."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key used to access Linux VMs."
  type        = string
  sensitive   = true
}

variable "frontend_vm_size" {
  description = "Frontend VM size."
  type        = string
  default     = "Standard_B1s"
}

variable "backend_vm_size" {
  description = "Backend VM size."
  type        = string
  default     = "Standard_B1s"
}

variable "runner_vm_size" {
  description = "Self-hosted runner VM size."
  type        = string
  default     = "Standard_B1s"
}

variable "sonarqube_vm_size" {
  description = "SonarQube VM size."
  type        = string
  default     = "Standard_B2s"
}

variable "sql_admin_username" {
  description = "SQL administrator username."
  type        = string
}

variable "sql_admin_password" {
  description = "SQL administrator password."
  type        = string
  sensitive   = true
}

variable "sql_database_sku_name" {
  description = "Azure SQL Database SKU."
  type        = string
  default     = "Basic"
}

variable "alert_email_address" {
  description = "Email address that receives Azure Monitor alert notifications."
  type        = string
}

variable "vm_cpu_alert_threshold" {
  description = "VM CPU alert threshold percentage."
  type        = number
  default     = 70
}

variable "sql_dtu_alert_threshold" {
  description = "SQL DTU alert threshold percentage."
  type        = number
  default     = 80
}

variable "shared_resource_group_name" {
  description = "Resource group name that contains shared resources such as ACR."
  type        = string
}

variable "acr_name" {
  description = "Shared Azure Container Registry name."
  type        = string
}