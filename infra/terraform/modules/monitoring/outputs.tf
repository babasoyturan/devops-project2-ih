output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "Log Analytics Workspace name."
  value       = azurerm_log_analytics_workspace.this.name
}

output "application_insights_id" {
  description = "Application Insights ID."
  value       = azurerm_application_insights.this.id
}

output "application_insights_name" {
  description = "Application Insights name."
  value       = azurerm_application_insights.this.name
}

output "application_insights_connection_string" {
  description = "Application Insights connection string."
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}

output "action_group_id" {
  description = "Azure Monitor Action Group ID."
  value       = azurerm_monitor_action_group.this.id
}