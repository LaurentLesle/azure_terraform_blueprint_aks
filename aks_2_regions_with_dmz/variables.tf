variable "aks_service_principal" {
    description = "Map of name and end_date of the azure AD application"
    type = "map"
}

variable "location_map" {
    description = "Default location to create the resources"
    type = "map"
    default = {
        region1     = "southeastasia"
        region2   = "eastasia"
    }
}

variable "subnets" {
    type = "map"
}

variable "vnet" {
    type = "map"
}

variable "resource_groups" {
    type = "map"
}

variable "waf_configuration_map" {
    description = "Map of the waf configuration"
    type        = "map"
}

variable "aks_map" {
    type = "map"
}

variable "dns_zone" {
    type = "map"
}

variable "analytics_workspace_name" {
  
}

variable "prefix" {
    description = "Prefix generated by the remote state (./deploy.sh)"
}