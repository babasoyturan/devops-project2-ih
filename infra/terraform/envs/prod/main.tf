data "azurerm_client_config" "current" {}

module "resource_group" {
  source = "../../modules/resource-group"

  name     = "rg-${local.name_prefix}"
  location = local.location
  tags     = local.tags
}

module "network" {
  source = "../../modules/network"

  name                = "vnet-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = local.vnet_address_space
  subnets             = local.subnets
  tags                = local.tags
}

module "nsg_app_gateway" {
  source = "../../modules/nsg"

  name                = "nsg-agw-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["app_gateway"]
  tags                = local.tags

  security_rules = [
    {
      name                       = "Allow-HTTP-From-Internet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      destination_port_range     = "80"
      description                = "Allow HTTP traffic from Internet to Application Gateway."
    },
    {
      name                       = "Allow-HTTPS-From-Internet"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      description                = "Allow HTTPS traffic from Internet to Application Gateway."
    },
    {
      name                       = "Allow-GatewayManager"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
      destination_port_range     = "65200-65535"
      description                = "Allow Azure GatewayManager traffic required for Application Gateway v2."
    }
  ]
}

module "nsg_frontend" {
  source = "../../modules/nsg"

  name                = "nsg-frontend-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["frontend"]
  tags                = local.tags

  security_rules = [
    {
      name                       = "Allow-HTTP-From-AppGateway"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.app_gateway.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "80"
      description                = "Allow frontend traffic from Application Gateway."
    },
    {
      name                       = "Allow-SSH-From-Ops"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.ops.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "22"
      description                = "Allow SSH from ops subnet for Ansible."
    },
    {
      name                       = "Allow-SSH-From-Bastion"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.bastion.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "22"
      description                = "Allow SSH from Azure Bastion subnet."
    },
    {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Deny all other inbound traffic."
    }
  ]
}

module "nsg_backend" {
  source = "../../modules/nsg"

  name                = "nsg-backend-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["backend"]
  tags                = local.tags

  security_rules = [
    {
      name                       = "Allow-API-From-AppGateway"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.app_gateway.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "8080"
      description                = "Allow backend API traffic from Application Gateway."
    },
    {
      name                       = "Allow-SSH-From-Ops"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.ops.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "22"
      description                = "Allow SSH from ops subnet for Ansible."
    },
    {
      name                       = "Allow-SSH-From-Bastion"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.bastion.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "22"
      description                = "Allow SSH from Azure Bastion subnet."
    },
    {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Deny all other inbound traffic."
    }
  ]
}

module "nsg_private_endpoints" {
  source = "../../modules/nsg"

  name                = "nsg-private-endpoints-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["private_endpoints"]
  tags                = local.tags

  security_rules = [
    {
      name                       = "Allow-SQL-From-Backend"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.backend.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "1433"
      description                = "Allow backend subnet to reach SQL private endpoint."
    },
    {
      name                       = "Allow-KeyVault-From-Backend"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.backend.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "443"
      description                = "Allow backend subnet to reach Key Vault private endpoint."
    },
    {
      name                       = "Allow-KeyVault-From-Ops"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.ops.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "443"
      description                = "Allow ops subnet to reach Key Vault private endpoint."
    },
    {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Deny all other inbound traffic."
    }
  ]
}

module "nsg_ops" {
  source = "../../modules/nsg"

  name                = "nsg-ops-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["ops"]
  tags                = local.tags

  security_rules = [
    {
      name                       = "Allow-SSH-From-Bastion"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.subnets.bastion.address_prefix
      destination_address_prefix = "*"
      destination_port_range     = "22"
      description                = "Allow SSH from Azure Bastion subnet to ops VM."
    },
    {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Deny all other inbound traffic to ops subnet."
    }
  ]
}

module "frontend_vm" {
  source = "../../modules/linux-vm"

  name                = "vm-fe-${local.name_prefix}-01"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["frontend"]
  vm_size             = var.frontend_vm_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  tags                = local.tags
}

module "backend_vm" {
  source = "../../modules/linux-vm"

  name                = "vm-be-${local.name_prefix}-01"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["backend"]
  vm_size             = var.backend_vm_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  tags                = local.tags
}

module "runner_vm" {
  source = "../../modules/linux-vm"

  name                = "vm-runner-${local.name_prefix}-01"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_ids["ops"]
  vm_size             = var.runner_vm_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  tags                = local.tags
}

module "bastion_public_ip" {
  source = "../../modules/public-ip"

  name                = "pip-bastion-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

module "bastion" {
  source = "../../modules/bastion"

  name                 = "bas-${local.name_prefix}"
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  sku                  = "Basic"
  subnet_id            = module.network.subnet_ids["bastion"]
  public_ip_address_id = module.bastion_public_ip.id
  tags                 = local.tags
}

module "azure_sql" {
  source = "../../modules/azure-sql"

  server_name                  = "sql-${local.name_prefix}"
  database_name                = "sqldb-${local.name_prefix}"
  resource_group_name          = module.resource_group.name
  location                     = module.resource_group.location
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  database_sku_name            = var.sql_database_sku_name
  storage_account_type         = "Local"
  tags                         = local.tags
}

module "key_vault" {
  source = "../../modules/key-vault"

  name                = "kv-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "sql_private_dns" {
  source = "../../modules/private-dns"

  name                = "privatelink.database.windows.net"
  vnet_link_name      = "pdnslink-sql-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  virtual_network_id  = module.network.vnet_id
  tags                = local.tags
}

module "keyvault_private_dns" {
  source = "../../modules/private-dns"

  name                = "privatelink.vaultcore.azure.net"
  vnet_link_name      = "pdnslink-kv-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  virtual_network_id  = module.network.vnet_id
  tags                = local.tags
}

module "sql_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                            = "pe-sql-${local.name_prefix}"
  resource_group_name             = module.resource_group.name
  location                        = module.resource_group.location
  subnet_id                       = module.network.subnet_ids["private_endpoints"]
  private_service_connection_name = "psc-sql-${local.name_prefix}"
  private_connection_resource_id  = module.azure_sql.server_id
  subresource_names               = ["sqlServer"]
  private_dns_zone_ids            = [module.sql_private_dns.id]
  tags                            = local.tags
}

module "keyvault_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                            = "pe-kv-${local.name_prefix}"
  resource_group_name             = module.resource_group.name
  location                        = module.resource_group.location
  subnet_id                       = module.network.subnet_ids["private_endpoints"]
  private_service_connection_name = "psc-kv-${local.name_prefix}"
  private_connection_resource_id  = module.key_vault.id
  subresource_names               = ["vault"]
  private_dns_zone_ids            = [module.keyvault_private_dns.id]
  tags                            = local.tags
}

module "app_gateway_public_ip" {
  source = "../../modules/public-ip"

  name                = "pip-agw-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

module "application_gateway" {
  source = "../../modules/application-gateway"

  name                 = "agw-${local.name_prefix}"
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  subnet_id            = module.network.subnet_ids["app_gateway"]
  public_ip_address_id = module.app_gateway_public_ip.id

  frontend_private_ip = module.frontend_vm.private_ip_address
  backend_private_ip  = module.backend_vm.private_ip_address

  enable_sonarqube = false

  frontend_port = 80
  backend_port  = 8080

  frontend_probe_path = "/"
  backend_probe_path  = "/api/health"

  sku_name = "WAF_v2"
  sku_tier = "WAF_v2"
  capacity = 1

  waf_enabled          = true
  waf_firewall_mode    = "Prevention"
  waf_rule_set_version = "3.2"

  routing_rule_priority = 100

  tags = local.tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix                  = local.name_prefix
  resource_group_name           = module.resource_group.name
  location                      = module.resource_group.location
  log_analytics_workspace_name  = "log-${local.name_prefix}"
  application_insights_name     = "appi-${local.name_prefix}"
  action_group_name             = "ag-alerts-${local.name_prefix}"
  action_group_short_name       = "g6prod"
  alert_email_address           = var.alert_email_address
  application_gateway_id        = module.application_gateway.id
  sql_database_id               = module.azure_sql.database_id
  vm_cpu_threshold              = var.vm_cpu_alert_threshold
  sql_dtu_threshold             = var.sql_dtu_alert_threshold

  vm_ids = [
    module.frontend_vm.id,
    module.backend_vm.id,
    module.runner_vm.id
  ]

  tags = local.tags
}

module "app_gateway_diagnostics" {
  source = "../../modules/diagnostic-setting"

  name                       = "diag-agw-${local.name_prefix}"
  target_resource_id         = module.application_gateway.id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  log_categories = [
    "ApplicationGatewayAccessLog",
    "ApplicationGatewayFirewallLog"
  ]

  metric_categories = [
    "AllMetrics"
  ]
}

module "key_vault_diagnostics" {
  source = "../../modules/diagnostic-setting"

  name                       = "diag-kv-${local.name_prefix}"
  target_resource_id         = module.key_vault.id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  log_categories = [
    "AuditEvent"
  ]

  metric_categories = [
    "AllMetrics"
  ]
}