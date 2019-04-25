
provider "azurerm" {
    version = "~>1.25"
}

terraform {
    backend "azurerm" {}
}


# Used to make sure delete / re-create generate brand new names and reduce risk of being throttled during dev activities
resource "random_string" "prefix" {
    length  = 4
    special = false
    upper   = false
    number  = false
}