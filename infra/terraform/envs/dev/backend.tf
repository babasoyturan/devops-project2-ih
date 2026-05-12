terraform {
  backend "azurerm" {
    resource_group_name  = "rg-g6-tfstate-plc"
    storage_account_name = "stg6tfstateplc60717"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
  }
}
