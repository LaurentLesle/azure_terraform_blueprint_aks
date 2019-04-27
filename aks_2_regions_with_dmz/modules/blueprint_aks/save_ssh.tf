# resource "null_resource" "save_ssh_key" {
  
#   provisioner "local-exec" {
#     command = "${local.arg_save_ssh_key}"
#   }

#   triggers = {
#     content = "${module.arg_save_ssh_key.private_key_pem}"
#     arg     = "${local.arg_save_ssh_key}"
#   }
# }

# locals {
#     arg_save_ssh_key = "cat > ~/.ssh/${azurerm_public_ip.bastion_pip.fqdn}.private <<EOL\n${module.arg_save_ssh_key.private_key_pem}\nEOL"
# }

# # Save the SSH key localy to connect the bastion server through SSH
# resource "null_resource" "save_ssh_config" {
#   depends_on = ["null_resource.save_ssh_key"]

#   provisioner "local-exec" {
#     command = "${local.arg_ssh_config}"
#   }

#   triggers = {
#     content     = "${local.arg_ssh_config}"
#   }
# }

# locals {
#     arg_ssh_config = "chmod 0600 ~/.ssh/${azurerm_public_ip.bastion_pip.fqdn}.private&&echo \"Host ${azurerm_public_ip.bastion_pip.fqdn}\" >> ~/.ssh/config&&echo \"  IdentityFile ~/.ssh/${azurerm_public_ip.bastion_pip.fqdn}.private\n\" >> ~/.ssh/config&&echo \"  StrictHostKeyChecking no\n\" >> ~/.ssh/config"
# }