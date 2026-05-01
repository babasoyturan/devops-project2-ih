output "resource_group_name" {
  description = "Dev resource group name."
  value       = module.resource_group.name
}

output "vnet_name" {
  description = "Dev VNet name."
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "Dev VNet ID."
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "Dev subnet IDs."
  value       = module.network.subnet_ids
}

output "subnet_names" {
  description = "Dev subnet names."
  value       = module.network.subnet_names
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

output "sonarqube_vm_private_ip" {
  description = "SonarQube VM private IP."
  value       = module.sonarqube_vm.private_ip_address
}

output "vm_private_ips" {
  description = "All Dev VM private IPs."
  value = {
    frontend  = module.frontend_vm.private_ip_address
    backend   = module.backend_vm.private_ip_address
    runner    = module.runner_vm.private_ip_address
    sonarqube = module.sonarqube_vm.private_ip_address
  }
}

output "vm_managed_identity_principal_ids" {
  description = "Managed identity principal IDs for Dev VMs."
  value = {
    frontend  = module.frontend_vm.principal_id
    backend   = module.backend_vm.principal_id
    runner    = module.runner_vm.principal_id
    sonarqube = module.sonarqube_vm.principal_id
  }
}

output "bastion_name" {
  description = "Dev Azure Bastion name."
  value       = module.bastion.name
}

output "bastion_public_ip" {
  description = "Dev Azure Bastion public IP."
  value       = module.bastion_public_ip.ip_address
}

output "sql_server_name" {
  description = "Dev SQL Server name."
  value       = module.azure_sql.server_name
}

output "sql_server_fqdn" {
  description = "Dev SQL Server FQDN."
  value       = module.azure_sql.server_fqdn
}

output "sql_database_name" {
  description = "Dev SQL Database name."
  value       = module.azure_sql.database_name
}

output "key_vault_name" {
  description = "Dev Key Vault name."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Dev Key Vault URI."
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
  description = "Dev Application Gateway name."
  value       = module.application_gateway.name
}

output "application_gateway_public_ip" {
  description = "Dev Application Gateway public IP."
  value       = module.app_gateway_public_ip.ip_address
}

output "log_analytics_workspace_name" {
  description = "Dev Log Analytics Workspace name."
  value       = module.monitoring.log_analytics_workspace_name
}

output "application_insights_name" {
  description = "Dev Application Insights name."
  value       = module.monitoring.application_insights_name
}

output "application_insights_connection_string" {
  description = "Application Insights connection string."
  value       = module.monitoring.application_insights_connection_string
  sensitive   = true
}