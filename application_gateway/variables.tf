variable "resource_group_name" {
  description = "Name of the resource group already created."

}


variable "waf_configuration_map" {
    description = "Map of the waf configuration"
    type        = "map"
}

variable "vnet_id" {
  
}


variable "prefix" {
  
}

variable "internal_ip_ingress" {
  
}

variable "location" {
  
}
