variable "aks_service_principal" {
    description = "Map of name and end_date of the azure AD application"
    type = "map"
}

variable "location" {
    description = "Location to create the resources"
}

variable "subnets" {
    type = "map"
}

variable "vnet" {
    type = "map"
}

variable "resource_group_names" {
    type = "map"
}

variable "resource_group_ids" {
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

variable "log_analytics_workspace_id" {
  
}

variable "prefix" {
  
}

variable "suffix" {
  
}
