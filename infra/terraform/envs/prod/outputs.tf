output "resource_group_name" {
  description = "Prod resource group name."
  value       = module.resource_group.name
}

output "vnet_name" {
  description = "Prod VNet name."
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "Prod VNet ID."
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "Prod subnet IDs."
  value       = module.network.subnet_ids
}

output "frontend_vm_private_ip" {
  description = "Frontend VM private IP."
  value       = module.frontend_vm.private_ip_address
}

output "backend_vm_private_ip" {
  description = "Backend VM private IP."
  value       = module.backend_vm.private_ip_address
}

output "runner_vm_private_ip" {
  description = "Runner VM private IP."
  value       = module.runner_vm.private_ip_address
}

output "vm_private_ips" {
  description = "All Prod VM private IPs."
  value = {
    frontend = module.frontend_vm.private_ip_address
    backend  = module.backend_vm.private_ip_address
    runner   = module.runner_vm.private_ip_address
  }
}

output "bastion_name" {
  description = "Prod Azure Bastion name."
  value       = module.bastion.name
}

output "bastion_public_ip" {
  description = "Prod Azure Bastion public IP."
  value       = module.bastion_public_ip.ip_address
}

output "sql_server_name" {
  description = "Prod SQL Server name."
  value       = module.azure_sql.server_name
}

output "sql_server_fqdn" {
  description = "Prod SQL Server FQDN."
  value       = module.azure_sql.server_fqdn
}

output "sql_database_name" {
  description = "Prod SQL Database name."
  value       = module.azure_sql.database_name
}

output "key_vault_name" {
  description = "Prod Key Vault name."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Prod Key Vault URI."
  value       = module.key_vault.vault_uri
}

output "sql_private_endpoint_ip" {
  description = "SQL Private Endpoint private IP."
  value       = module.sql_private_endpoint.private_ip_address
}

output "keyvault_private_endpoint_ip" {
  description = "Key Vault Private Endpoint private IP."
  value       = module.keyvault_private_endpoint.private_ip_address
}

output "application_gateway_name" {
  description = "Prod Application Gateway name."
  value       = module.application_gateway.name
}

output "application_gateway_public_ip" {
  description = "Prod Application Gateway public IP."
  value       = module.app_gateway_public_ip.ip_address
}

output "log_analytics_workspace_name" {
  description = "Prod Log Analytics Workspace name."
  value       = module.monitoring.log_analytics_workspace_name
}

output "application_insights_name" {
  description = "Prod Application Insights name."
  value       = module.monitoring.application_insights_name
}

output "application_insights_connection_string" {
  description = "Application Insights connection string."
  value       = module.monitoring.application_insights_connection_string
  sensitive   = true
}