resource "azurerm_dns_zone" "dns" {
  name                = "${var.dns_zone["name"]}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  zone_type           = "${var.dns_zone["zone_type"]}"
}