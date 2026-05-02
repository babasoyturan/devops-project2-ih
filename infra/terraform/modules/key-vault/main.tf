resource "azurerm_key_vault" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = var.tenant_id
  sku_name                      = var.sku_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled
  rbac_authorization_enabled    = true

  network_acls {
    bypass                     = var.network_acls_bypass
    default_action             = var.network_acls_default_action
    virtual_network_subnet_ids = var.network_acls_virtual_network_subnet_ids
  }

  tags = var.tags
}