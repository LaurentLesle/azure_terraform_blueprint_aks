resource "null_resource" "install_docker" {
  depends_on = ["azurerm_virtual_machine.bastion"]

  triggers = {
    version = "${join(",", local.args)}"
  }

  connection {
        type                = "ssh"
        user                = "${local.bastion_admin_username}"
        host                = "${azurerm_public_ip.bastion_pip.fqdn}"
        private_key         = "${tls_private_key.ssh_bastion.private_key_pem}"
        agent               = false
    }

  provisioner "remote-exec" {
    
    inline = "${local.args}"
  }
}

locals {
    args = [
        "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
        "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
        "sudo yum makecache fast",
        "#sudo yum -y upgrade",

        "sudo yum install -y docker-ce",
        "sudo usermod -aG docker ${local.bastion_admin_username}",

        "sudo systemctl daemon-reload",
        "sudo systemctl enable docker",
        "sudo service docker start "

    ]
}


