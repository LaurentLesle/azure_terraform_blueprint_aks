# Create the resource groups to host the blueprint
module "resource_group" {
    source                  = "git://github.com/LaurentLesle/azure_terraform_blueprint_modules_resource_group.git"
  
    prefix                  = "${var.prefix}"
    resource_groups         = "${var.resource_groups}"
    location                = "${var.location_map["region1"]}"
}

# Create the Azure Monitor workspace
module "monitoring_workspace" {
    source                  = "log_analytics"
    
    prefix                  = "${var.prefix}"
    name                    = "${var.analytics_workspace_name}"
    resource_group_name     = "${module.resource_group.names["aks"]}"
    location                = "${var.location_map["region1"]}"
}

# Register the Azure dns service to an existing domain name
module "azure_dns" {
    source                              = "git://github.com/LaurentLesle/azure_terraform_blueprint_modules_azure_dns.git"
    
    resource_group_name                 = "${module.resource_group.names["networking"]}"
    dns_zone                            = "${var.dns_zone["external"]}"
}

module "aks_region1" {
    source                      = "aks_with_dmz"

    prefix                      = "${var.prefix}"
    suffix                      = "sg"
    resource_group_names        = "${module.resource_group.names}"
    resource_group_ids          = "${module.resource_group.ids}"
    dns_zone                    = "${var.dns_zone["internal"]}"     
    log_analytics_workspace_id  = "${module.monitoring_workspace.id}"
    aks_map                     = "${var.aks_map["region1"]}"      
    location                    = "${var.location_map["region1"]}"
    vnet                        = "${var.vnet["region1"]}"
    subnets                     = "${var.subnets["region1"]}"
    waf_configuration_map       = "${var.waf_configuration_map["region1"]}"
    aks_service_principal       = "${var.aks_service_principal["region1"]}"
}

module "aks_region2" {
    source                      = "aks_with_dmz"

    prefix                      = "${var.prefix}"
    suffix                      = "hk"
    resource_group_names        = "${module.resource_group.names}"
    resource_group_ids          = "${module.resource_group.ids}"
    dns_zone                    = "${var.dns_zone["internal"]}"    
    log_analytics_workspace_id  = "${module.monitoring_workspace.id}"
    aks_map                     = "${var.aks_map["region2"]}"       
    location                    = "${var.location_map["region2"]}"
    vnet                        = "${var.vnet["region2"]}"
    subnets                     = "${var.subnets["region2"]}"
    waf_configuration_map       = "${var.waf_configuration_map["region2"]}"
    aks_service_principal       = "${var.aks_service_principal["region2"]}"
}

