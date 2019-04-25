
aks_service_principal {
    primary {
        user_msi    = "msi-clusterdev01pri"      # Max 24 char including prefix (prefix 4 + 1)
        name        = "aks-clusterdev01pri"
        end_date    = "2020-01-01T01:02:03Z"    # To be refactored to Date + Duration
    }
    secondary {
        user_msi    = "msi-clusterdev01sec"      # Max 24 char including prefix (prefix 4 + 1)
        name        = "aks-clusterdev01sec"
        end_date    = "2020-01-01T01:02:03Z"    # To be refactored to Date + Duration
    }
}

location_map {
    "primary"     = "southeastasia"
    "secondary"   = "eastasia"
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
    primary {
        gateway_name                    = "app-gw01-sg"
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
    secondary {
        gateway_name                    = "app-gw01-hk"
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
    primary {
        aks_name                    = "aks-cluster1-sg"
        aks_version                 = "1.12.7"
        vm_user_name                = "aks-king"
        aks_agent_count             = "1"
        aks_agent_vm_size           = "Standard_DS4_v2"
        aks_agent_os_disk_size      = "32"
        aks_dns_service_ip          = "10.30.0.132"
        aks_docker_bridge_cidr      = "172.17.0.1/16"
        aks_service_cidr            = "10.30.0.128/25"
    }
    secondary {
        aks_name                    = "aks-cluster1-hk"
        aks_version                 = "1.12.7"
        vm_user_name                = "aks-king"
        aks_agent_count             = "1"
        aks_agent_vm_size           = "Standard_DS4_v2"
        aks_agent_os_disk_size      = "32"
        aks_dns_service_ip          = "10.31.0.132"
        aks_docker_bridge_cidr      = "172.17.0.1/16"
        aks_service_cidr            = "10.31.0.128/25"
    }
}

subnets {
    primary {
        "0_kubernetes"              = "aks-cluster1"
        "1_applicationGateway"      = "appgw-aks-cluster1"
        "2_bastion"                 = "bastion1"
    }
    secondary {
        "0_kubernetes"              = "aks-cluster1"
        "1_applicationGateway"      = "appgw-aks-cluster1"
        "2_bastion"                 = "bastion1"
    }
    
}

vnet {
    primary {
        name                    = "vnet-aks"
        address_space           = "10.30.0.0/16"
        aks-cluster1            = "10.30.0.0/25"
        appgw-aks-cluster1      = "10.30.254.0/24"
        bastion1                = "10.30.253.0/24"
    }
    secondary {
        name                    = "vnet-aks-hk"
        address_space           = "10.31.0.0/16"
        aks-cluster1            = "10.31.0.0/25"
        appgw-aks-cluster1      = "10.31.254.0/24"
        bastion1                = "10.31.253.0/24"
    }
}

dns_zone {
    name        = "thedemo.biz"
    zone_type   = "Public"
}

analytics_workspace_name = "aks"