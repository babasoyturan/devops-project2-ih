locals {
  project     = "burger"
  group       = "g6"
  environment = "prod"
  location    = var.location
  region_code = "plc"

  name_prefix = "${local.group}-${local.project}-${local.environment}-${local.region_code}"

  tags = {
    project     = local.project
    group       = local.group
    environment = local.environment
    managed_by  = "terraform"
  }

  vnet_address_space = ["10.70.0.0/16"]

  subnets = {
    app_gateway = {
      name           = "snet-agw"
      address_prefix = "10.70.0.0/24"
    }

    frontend = {
      name           = "snet-frontend"
      address_prefix = "10.70.1.0/24"
    }

    backend = {
      name           = "snet-backend"
      address_prefix = "10.70.2.0/24"
    }

    private_endpoints = {
      name                              = "snet-private-endpoints"
      address_prefix                    = "10.70.3.0/24"
      private_endpoint_network_policies = "Disabled"
    }

    ops = {
      name           = "snet-ops"
      address_prefix = "10.70.4.0/24"
    }

    # Kept for network shape consistency, but no SonarQube VM is created in prod.
    sonarqube = {
      name           = "snet-sonarqube"
      address_prefix = "10.70.5.0/24"
    }

    bastion = {
      name           = "AzureBastionSubnet"
      address_prefix = "10.70.6.0/26"
    }
  }
}