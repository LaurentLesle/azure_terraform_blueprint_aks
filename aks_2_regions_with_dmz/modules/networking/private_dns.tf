# Internal DNS used to host the applications published through the ingress controller
module "azure_dns_internal" {
    source                              = "../azure_dns"
    
    resource_group_name                 = "${var.resource_group_name}"
    dns_zone                            = "${var.dns_zone}"
    subdomain                           = "${var.location}."
    resolution_virtual_network_ids      = ["${azurerm_virtual_network.vnet.id}"]
}