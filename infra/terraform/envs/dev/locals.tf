locals {
  project     = "burger"
  group       = "g6"
  environment = "dev"
  location    = var.location
  region_code = "plc"

  name_prefix = "${local.group}-${local.project}-${local.environment}-${local.region_code}"

  tags = {
    project     = local.project
    group       = local.group
    environment = local.environment
    managed_by  = "terraform"
  }

  vnet_address_space = ["10.60.0.0/16"]

  subnets = {
    app_gateway = {
      name           = "snet-agw"
      address_prefix = "10.60.0.0/24"
    }

    frontend = {
      name           = "snet-frontend"
      address_prefix = "10.60.1.0/24"
    }

    backend = {
      name           = "snet-backend"
      address_prefix = "10.60.2.0/24"
    }

    private_endpoints = {
      name                              = "snet-private-endpoints"
      address_prefix                    = "10.60.3.0/24"
      private_endpoint_network_policies = "Disabled"
    }

    ops = {
      name           = "snet-ops"
      address_prefix = "10.60.4.0/24"
    }

    sonarqube = {
      name           = "snet-sonarqube"
      address_prefix = "10.60.5.0/24"
    }

    bastion = {
      name           = "AzureBastionSubnet"
      address_prefix = "10.60.6.0/26"
    }
  }
}
