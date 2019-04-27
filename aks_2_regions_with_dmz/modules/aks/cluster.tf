resource "random_string" "dns_prefix" {
    length              = 44
    upper               = false
    special             = true
    override_special    = "-"
}

locals {
    dns_prefix  = "a${random_string.dns_prefix.result}"
}


resource "azurerm_kubernetes_cluster" "k8s" {

    depends_on = [
        "azurerm_role_assignment.ra1",
        "azurerm_role_assignment.ra2"
    ]

    name                    = "${var.prefix}-${var.aks_map["aks_name"]}"
    resource_group_name     = "${var.resource_group_name}"
    location                = "${var.location}"
    dns_prefix              = "${local.dns_prefix}"
    kubernetes_version      = "${var.aks_map["aks_version"]}"

    linux_profile {
        admin_username = "${var.aks_map["vm_user_name"]}"

        ssh_key {
            key_data = "${var.public_ssh_key_openssh}"
        }
    }

    addon_profile {
        http_application_routing {
            enabled = false
        }

        oms_agent {
            enabled                    = true
            log_analytics_workspace_id = "${var.log_analytics_workspace_id}"
        }
    }

    agent_pool_profile {
        name            = "agentpool"
        count           = "${var.aks_map["aks_agent_count"]}"
        vm_size         = "${var.aks_map["aks_agent_vm_size"]}"
        os_type         = "Linux"
        os_disk_size_gb = "${var.aks_map["aks_agent_os_disk_size"]}"
        vnet_subnet_id  = "${var.subnets_map["${var.aks_subnet_name}"]}"
        
    }

    service_principal {
        client_id     = "${var.service_principal_map["app_id"]}"
        client_secret = "${var.service_principal_map["client_secret"]}"
    }

    network_profile {
        network_plugin     = "azure"
        dns_service_ip     = "${var.aks_map["aks_dns_service_ip"]}"
        docker_bridge_cidr = "${var.aks_map["aks_docker_bridge_cidr"]}"
        service_cidr       = "${var.aks_map["aks_service_cidr"]}"
    }

}