locals {
    rg_list = "${keys(var.resource_groups)}"
}



resource "azurerm_resource_group" "rg" {
    count                   = "${length(local.rg_list)}"

    name                    = "${var.prefix}-${var.resource_groups[element(local.rg_list, count.index)]}"
    location                = "${var.location}"
}
