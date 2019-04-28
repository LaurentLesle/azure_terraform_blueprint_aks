variable "prefix" {
    description = "Default prefix to be used by all objects."
}

variable "computer_name" {
  
}

variable "vm_size" {
  
}

variable "subnets_map" {
    description = "Map of the subnet to deploy the bastion server" 
    type = "map"
}

variable "subnet_name" {
    description = "Name of the subnet to deploy the bastion server"
}


variable "location" {
    description = "Location to create resource groups and region1 resources."
}

variable "resource_group_name" {
  
}

