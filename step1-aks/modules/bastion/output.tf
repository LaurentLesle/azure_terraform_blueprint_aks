
output "bastion_connection" {
  depends_on = [
    "azurerm_virtual_machine.bastion", 
    "null_resource.save_ssh_key", 
    "null_resource.install_docker"
  ]
  sensitive = true
  value = "${
    map(
      "admin_username",   "${local.bastion_admin_username}",
      "hostname",         "${azurerm_public_ip.bastion_pip.fqdn}",
      "ssh_private_key",  "${tls_private_key.ssh_bastion.private_key_pem}",
      "msi_principal_id", "${lookup(azurerm_virtual_machine.bastion.identity[0], "principal_id")}"
    )
  }"
}
