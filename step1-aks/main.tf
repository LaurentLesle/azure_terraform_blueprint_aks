# Create the resource groups to host the blueprint
module "resource_group" {
    source                  = "modules/resource_group"
  
    prefix                  = "${var.prefix}"
    resource_groups         = "${var.resource_groups}"
    location                = "${var.location_map["primary"]}"
}

# Create the Azure Monitor workspace
module "monitoring_workspace" {
    source                  = "modules/log_analytics"
    
    prefix                  = "${var.prefix}"
    name                    = "${var.analytics_workspace_name}"
    resource_group_name     = "${module.resource_group.names["aks"]}"
    location                = "${var.location_map["primary"]}"
}

# Register the Azure dns service to an existing domain name
module "azure_dns" {
    source                              = "modules/azure_dns"
    
    resource_group_name                 = "${module.resource_group.names["networking"]}"
    dns_zone                            = "${var.dns_zone["external"]}"
}

module "aks_primary" {
    source                      = "modules/blueprint_aks"

    prefix                      = "${var.prefix}"
    suffix                      = "sg"
    resource_group_names        = "${module.resource_group.names}"
    resource_group_ids          = "${module.resource_group.ids}"
    log_analytics_workspace_id  = "${module.monitoring_workspace.id}"
    aks_map                     = "${var.aks_map["primary"]}"
    dns_zone                    = "${var.dns_zone["internal"]}"           
    location                    = "${var.location_map["primary"]}"
    vnet                        = "${var.vnet["primary"]}"
    subnets                     = "${var.subnets["primary"]}"
    waf_configuration_map       = "${var.waf_configuration_map["primary"]}"
    aks_service_principal       = "${var.aks_service_principal["primary"]}"
}

module "aks_secondary" {
    source                      = "modules/blueprint_aks"

    prefix                      = "${var.prefix}"
    suffix                      = "hk"
    resource_group_names        = "${module.resource_group.names}"
    resource_group_ids          = "${module.resource_group.ids}"
    log_analytics_workspace_id  = "${module.monitoring_workspace.id}"
    aks_map                     = "${var.aks_map["secondary"]}"
    dns_zone                    = "${var.dns_zone["internal"]}"           
    location                    = "${var.location_map["secondary"]}"
    vnet                        = "${var.vnet["secondary"]}"
    subnets                     = "${var.subnets["secondary"]}"
    waf_configuration_map       = "${var.waf_configuration_map["secondary"]}"
    aks_service_principal       = "${var.aks_service_principal["secondary"]}"
}

