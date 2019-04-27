output "subnet_map" {
  depends_on = ["module.azure_dns_internal"]

  value = "${
      "${zipmap(azurerm_subnet.subnets.*.name,azurerm_subnet.subnets.*.id)}"
  }"
}

output "vnet_id" {
  depends_on = ["module.azure_dns_internal"]
  value = "${azurerm_virtual_network.vnet.id}"
}