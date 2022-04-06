variable "github_token"" {
  type = string
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}
