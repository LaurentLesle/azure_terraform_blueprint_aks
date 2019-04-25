
output "subnet_map" {
  value = "${
      "${zipmap(azurerm_subnet.subnets.*.name,azurerm_subnet.subnets.*.id)}"
  }"
}

output "vnet_id" {
  value = "${azurerm_virtual_network.vnet.id}"
}