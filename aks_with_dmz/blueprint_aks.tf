## Blueprint: AKS with Application Gateway as ingress controller
# reference: https://github.com/Azure/application-gateway-kubernetes-ingress


# Create service principal for the AKS cluster
module "aks_service_principal" {
    source                  = "git://github.com/LaurentLesle/azure_terraform_blueprint_modules_service_principal.git?ref=v1.0"
    
    prefix                  = "${var.prefix}"
    name                    = "${var.aks_service_principal["name"]}"
    end_date                = "${var.aks_service_principal["end_date"]}"
}

# Create the user assigned identity
module "user_msi" {
    source                  = "git://github.com/LaurentLesle/azure_terraform_blueprint_modules_user_identity.git?ref=v1.1"
  
    prefix                  = "${var.prefix}"
    resource_group_name     = "${var.resource_group_names["identity"]}"
    location                = "${var.location}"
    name                    = "${var.aks_service_principal["user_msi"]}"
}

# Generate the ssh keys
module "aks_ssh_keys" {
    source                  = "git://github.com/LaurentLesle/azure_terraform_blueprint_modules_ssh_keys.git?ref=v1.0.1"
}

# Create the network environment
module "vnet_and_subnets" {
    source                  = "git://github.com/LaurentLesle/azure_terraform_blueprint_modules_networking.git?ref=v1.2"

    location                = "${var.location}"
    resource_group_name     = "${var.resource_group_names["networking"]}"
    prefix                  = "${var.prefix}"
    vnet                    = "${var.vnet}"
    subnets                 = "${var.subnets}"
    dns_zone                = "${var.dns_zone}"
}



module "application_gateway" {
    source                  = "../application_gateway"

    prefix                  = "${var.prefix}"
    resource_group_name     = "${var.resource_group_names["appgateway"]}"
    location                = "${var.location}"
    vnet_id                 = "${module.vnet_and_subnets.vnet["id"]}"
    waf_configuration_map   = "${var.waf_configuration_map}"
    internal_ip_ingress     = "${module.aks_cluster.nginx-ingress_loadbalancer_ip}"
}


# Managed Kubernetes Cluster
module "aks_cluster" {
    source                      = "git://github.com/LaurentLesle/azure_terraform_blueprint_modules_aks.git?ref=v1.2.1"
    
    prefix                      = "${var.prefix}"
    location                    = "${var.location}"
    resource_group_name         = "${var.resource_group_names["aks"]}"
    resource_group_id           = "${var.resource_group_ids["aks"]}"
    vnet_resource_group_name    = "${var.resource_group_names["networking"]}"
    public_ssh_key_openssh      = "${module.aks_ssh_keys.public_key_openssh}"
    service_principal_map       = "${module.aks_service_principal.service_principal_map}"
    user_msi_map                = "${module.user_msi.map}" 
    virtual_network_name        = "${var.vnet["name"]}"
    subnet_ids                  = "${module.vnet_and_subnets.subnet_ids}"
    appgw_subnet_name           = "${var.waf_configuration_map["subnet_name"]}"
    aks_map                     = "${var.aks_map}"
    log_analytics_workspace_id  = "${var.log_analytics_workspace_id}"
    default_dns_name            = "${var.dns_zone["name"]}"
}


module "bastion" {
    source              = "../bastion"

    prefix              = "${var.prefix}"
    location            = "${var.location}"
    computer_name       = "bastion-${var.suffix}"
    vm_size             = "Standard_F2s_v2"
    subnet_id           = "${module.vnet_and_subnets.subnet_ids["bastion1"]}"
    resource_group_name = "${var.resource_group_names["bastion"]}"
}