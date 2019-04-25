resource "azurerm_role_assignment" "ra1" {
  scope                = "${var.subnets_map["${var.aks_subnet_name}"]}"
  role_definition_name = "Network Contributor"
  principal_id         = "${var.service_principal_map["object_id"]}"
}

resource "azurerm_role_assignment" "ra2" {
  scope                = "${var.user_msi_map["id"]}"
  role_definition_name = "Managed Identity Operator"
  principal_id         = "${var.service_principal_map["object_id"]}"
}

resource "azurerm_role_assignment" "ra3" {
  scope                = "${var.subnets_map["${var.appgw_subnet_name}"]}"
  role_definition_name = "Contributor"
  principal_id         = "${var.user_msi_map["principal_id"]}"
}

resource "azurerm_role_assignment" "ra4" {
  scope                = "${data.azurerm_resource_group.rg.id}"
  role_definition_name = "Reader"
  principal_id         = "${var.user_msi_map["principal_id"]}"
}