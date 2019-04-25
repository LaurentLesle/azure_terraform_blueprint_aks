data "azurerm_resource_group" "rg" {
    name = "${var.resource_group_name}"
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "${var.prefix}-${var.name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${var.resource_group_name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.log.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.log.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}