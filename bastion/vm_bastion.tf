

resource "tls_private_key" "ssh_bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_string" "public_dns_prefix" {
    length  = 31
    upper   = false
    special = false
}


locals {
  bastion_admin_username = "bastion.king"

  # must start with a letter
  dns_prefix = "a${random_string.public_dns_prefix.result}"
}



resource "azurerm_public_ip" "bastion_pip" {
  name                         = "${var.computer_name}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Dynamic"
  domain_name_label            = "${local.dns_prefix}"
}

resource "azurerm_network_interface" "bastion" {
  name                         = "${var.computer_name}-nic"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"

  ip_configuration {
    name      = "${var.computer_name}-ipconfig"
    subnet_id = "${var.subnet_id}"

    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.bastion_pip.id}"
  }
}

resource "azurerm_virtual_machine" "bastion" {
  name                  = "${var.computer_name}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.bastion.id}"]

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher       = "OpenLogic"
    offer           = "CentOS"
    sku             = "7.5"
    version         = "latest"
  }

  storage_os_disk {
    name              = "${var.computer_name}-osdisk"
    managed_disk_type = "Premium_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = "32"
  }

  os_profile {
    computer_name  = "${var.computer_name}"
    admin_username = "${local.bastion_admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys = [
      {
        path     = "/home/${local.bastion_admin_username}/.ssh/authorized_keys"
        key_data = "${tls_private_key.ssh_bastion.public_key_openssh}"
      },
    ]
  }

  identity {
      type = "SystemAssigned"
  }


  provisioner "local-exec" {
    command = "az vm restart --name ${azurerm_virtual_machine.bastion.name} --resource-group ${var.resource_group_name}"
  }

}

resource "null_resource" "save_ssh_key" {
  
  provisioner "local-exec" {
    command = "${local.arg_save_ssh_key}"
  }

  triggers = {
    content = "${tls_private_key.ssh_bastion.private_key_pem}"
    arg     = "${local.arg_save_ssh_key}"
  }
}

locals {
    arg_save_ssh_key = "cat > ~/.ssh/${azurerm_public_ip.bastion_pip.fqdn}.private <<EOL\n${tls_private_key.ssh_bastion.private_key_pem}\nEOL"
}

# Save the SSH key localy to connect the bastion server through SSH
resource "null_resource" "save_ssh_config" {
  depends_on = ["null_resource.save_ssh_key"]

  provisioner "local-exec" {
    command = "${local.arg_ssh_config}"
  }

  triggers = {
    content     = "${local.arg_ssh_config}"
  }
}

locals {
    arg_ssh_config = "chmod 0600 ~/.ssh/${azurerm_public_ip.bastion_pip.fqdn}.private&&echo \"Host ${azurerm_public_ip.bastion_pip.fqdn}\" >> ~/.ssh/config&&echo \"  IdentityFile ~/.ssh/${azurerm_public_ip.bastion_pip.fqdn}.private\n\" >> ~/.ssh/config&&echo \"  StrictHostKeyChecking no\n\" >> ~/.ssh/config"
}