data "azurerm_resource_group" "rg" {
    name = "${var.resource_group_name}"
}

resource "azurerm_user_assigned_identity" "msi" {
    resource_group_name     = "${data.azurerm_resource_group.rg.name}"
    location                = "${data.azurerm_resource_group.rg.location}"

    name = "${var.prefix}-${var.name}"
}