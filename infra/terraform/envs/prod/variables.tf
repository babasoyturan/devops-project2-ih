variable "location" {
  description = "Azure region."
  type        = string
  default     = "polandcentral"
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
  default     = "Standard_D2s_v3"
}

variable "backend_vm_size" {
  description = "Backend VM size."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "runner_vm_size" {
  description = "Self-hosted runner VM size."
  type        = string
  default     = "Standard_D2s_v3"
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