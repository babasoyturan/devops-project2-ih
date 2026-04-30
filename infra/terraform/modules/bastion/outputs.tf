output "id" {
  description = "Azure Bastion host ID."
  value       = azurerm_bastion_host.this.id
}

output "name" {
  description = "Azure Bastion host name."
  value       = azurerm_bastion_host.this.name
}