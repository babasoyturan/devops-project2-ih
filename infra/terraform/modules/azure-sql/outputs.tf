output "server_id" {
  description = "Azure SQL Server ID."
  value       = azurerm_mssql_server.this.id
}

output "server_name" {
  description = "Azure SQL Server name."
  value       = azurerm_mssql_server.this.name
}

output "server_fqdn" {
  description = "Azure SQL Server FQDN."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "Azure SQL Database ID."
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "Azure SQL Database name."
  value       = azurerm_mssql_database.this.name
}