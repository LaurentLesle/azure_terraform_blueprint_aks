
aks_service_principal {
    region1 {
        user_msi    = "msi-clusterdev01sg"      # Max 24 char including prefix (prefix 4 + 1)
        name        = "aks-clusterdev01sg"
        end_date    = "2020-01-01T01:02:03Z"    # To be refactored to Date + Duration
    }
    region2 {
        user_msi    = "msi-clusterdev01hk"      # Max 24 char including prefix (prefix 4 + 1)
        name        = "aks-clusterdev01hk"
        end_date    = "2020-01-01T01:02:03Z"    # To be refactored to Date + Duration
    }
}

location_map {
    "region1"     = "southeastasia"
    "region2"   = "eastasia"
}

# Key is lexically sorted - adding after a deployment can cause the deployed resources to be deleted and recreated
resource_groups {
    "networking"      = "AKS-CLUSTER1-NETWORKING"
    "identity"        = "AKS-CLUSTER1-IDENTITY"
    "aks"             = "AKS-CLUSTER1-AKS"
    "appgateway"      = "AKS-CLUSTER1-APPGW"
    "bastion"         = "AKS-CLUSTER1-BASTION"
}

waf_configuration_map {
    region1 {
        gateway_name                    = "app-gw01-sg"
        subnet_name                     = "appgw-aks-cluster1"
        sku_name                        = "WAF_V2"
        sku_tier                        = "WAF_V2"
        capacity_sku                    = 1      
        pip_sku                         = "Standard"    
        pip_allocation                  = "Static"   
        firewall_mode                   = "Prevention"
        rule_set_type                   = "OWASP"
        rule_set_version                = "3.0"
        waf_enabled                     = true
        frontend_port                   = 80
        backend_port                    = 80
        backend_protocol                = "Http"
        request_timeout                 = 5             # in seconds
        cookie_based_affinity           = "Enabled"
        request_routing_rule_rule_type  = "Basic"   
    }
    region2 {
        gateway_name                    = "app-gw01-hk"
        subnet_name                     = "appgw-aks-cluster1"
        sku_name                        = "WAF_Medium"
        sku_tier                        = "WAF"
        capacity_sku                    = 1             
        pip_sku                         = "Basic"    
        pip_allocation                  = "Dynamic"   
        firewall_mode                   = "Prevention"
        rule_set_type                   = "OWASP"
        rule_set_version                = "3.0"
        waf_enabled                     = true
        frontend_port                   = 80
        backend_port                    = 80
        backend_protocol                = "Http"
        request_timeout                 = 5             # in seconds
        cookie_based_affinity           = "Enabled"
        request_routing_rule_rule_type  = "Basic"  
    }
}


aks_map {
    region1 {
        aks_name                    = "aks-cluster1-sg"
        subnet_name                 = "aks-cluster1"
        aks_version                 = "1.12.7"
        vm_user_name                = "aks-king"
        aks_agent_count             = "1"
        aks_agent_vm_size           = "Standard_DS4_v2"
        aks_agent_os_disk_size      = "32"
        aks_dns_service_ip          = "172.17.0.10"      # IP from aks-cluster1 aks_service_cidr
        aks_docker_bridge_cidr      = "172.16.0.1/16"
        aks_service_cidr            = "172.17.0.0/16"
        aks_pod_cidr                = "172.18.0.0/16"
        aks_netPlugin               = "kubenet" 
    }
    region2 {
        aks_name                    = "aks-cluster1-hk"
        subnet_name                 = "aks-cluster1"
        aks_version                 = "1.12.7"
        vm_user_name                = "aks-king"
        aks_agent_count             = "1"
        aks_agent_vm_size           = "Standard_DS4_v2"
        aks_agent_os_disk_size      = "32"
        aks_dns_service_ip          = "172.20.0.10"     # IP from aks-cluster1 aks_service_cidr
        aks_docker_bridge_cidr      = "172.19.0.1/16"
        aks_service_cidr            = "172.20.0.0/16"
        aks_pod_cidr                = "172.21.0.0/16"
        aks_netPlugin               = "kubenet" 
    }
}


vnet {
    region1 {
        name                    = "vnet-aks-sg"
        address_space           = "10.30.0.0/16"
    }
    region2 {
        name                    = "vnet-aks-hk"
        address_space           = "10.130.0.0/16"
    }
}

subnets {
    region1 {
        aks-cluster1            = "10.30.253.0/25"
        appgw-aks-cluster1      = "10.30.253.128/25"
        bastion1                = "10.30.254.0/24"
    }
    region2 {
        aks-cluster1            = "10.130.253.0/25"
        appgw-aks-cluster1      = "10.130.253.128/25"
        bastion1                = "10.130.254.0/24"
    }
    
}



dns_zone {
    external {
        name        = "thedemo.biz"
        zone_type   = "Public"
    }
    internal {
        name        = "aks.internal"
        zone_type   = "Private"
    }
}

analytics_workspace_name = "aks"