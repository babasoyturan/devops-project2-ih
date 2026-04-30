locals {
  project     = "burger"
  group       = "g6"
  environment = "shared"
  location    = var.location
  region_code = "plc"

  name_prefix = "${local.group}-${local.project}-${local.environment}-${local.region_code}"

  tags = {
    project     = local.project
    group       = local.group
    environment = local.environment
    managed_by  = "terraform"
  }
}
