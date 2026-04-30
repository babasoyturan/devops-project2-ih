output "shared_resource_group_name" {
  description = "Shared resource group name."
  value       = module.resource_group.name
}

output "acr_name" {
  description = "Shared ACR name."
  value       = module.acr.name
}

output "acr_id" {
  description = "Shared ACR resource ID."
  value       = module.acr.id
}

output "acr_login_server" {
  description = "Shared ACR login server."
  value       = module.acr.login_server
}