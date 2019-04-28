
provider "azurerm" {
    version = "~>1.27.1"
}

terraform {
    backend "azurerm" {}
}

