variable "aks_map" {
    description = "Map of attributes: aks_name, aks_dns_prefix, vm_user_name, aks_agent_count, aks_agent_vm_size, aks_agent_os_disk_size, aks_dns_service_ip, aks_docker_bridge_cidr, aks_service_cidr"
    type = "map"
}


variable "resource_group_name" {
    description = "Resource group name for AKS"
}

variable "resource_group_id" {

}

variable "vnet_resource_group_name" {
  
}


variable "service_principal_map" {
  description = "Map of appId, ObjectId, ClientSecret. Used by AKS to manage AKS related resources on Azure like vms, subnets."
  type = "map"
}

variable "user_msi_map" {
    type = "map"
}


variable "virtual_network_name" {
  description = "Virtual network name"
}

variable "aks_subnet_name" {
  description = "AKS Subnet Name."
}

variable "appgw_subnet_name" {
  description = "Application Gateway Subnet Name."
}


variable "public_ssh_key_openssh" {
  description = "Public key in openssh format for SSH."
}

variable "prefix" {
  
}

variable "subnets_map" {
    type = "map"
}

variable "log_analytics_workspace_id" {
}

variable "default_dns_name" {
  
}

variable "location" {
  
}

