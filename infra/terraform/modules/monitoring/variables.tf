variable "name_prefix" {
  description = "Common resource name prefix."
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

variable "log_analytics_workspace_name" {
  description = "Log Analytics Workspace name."
  type        = string
}

variable "application_insights_name" {
  description = "Application Insights name."
  type        = string
}

variable "log_analytics_sku" {
  description = "Log Analytics Workspace SKU."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Log retention in days."
  type        = number
  default     = 30
}

variable "action_group_name" {
  description = "Azure Monitor Action Group name."
  type        = string
}

variable "action_group_short_name" {
  description = "Action Group short name. Maximum 12 characters."
  type        = string
}

variable "alert_email_address" {
  description = "Email address that receives Azure Monitor alert notifications."
  type        = string
}

variable "application_gateway_id" {
  description = "Application Gateway resource ID."
  type        = string
}

variable "vm_ids" {
  description = "List of VM resource IDs monitored by the CPU alert."
  type        = list(string)
}

variable "sql_database_id" {
  description = "SQL Database resource ID monitored by the DTU alert."
  type        = string
}

variable "vm_cpu_threshold" {
  description = "VM CPU alert threshold percentage."
  type        = number
  default     = 70
}

variable "sql_dtu_threshold" {
  description = "SQL DTU alert threshold percentage."
  type        = number
  default     = 80
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}