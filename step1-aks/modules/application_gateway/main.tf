data "azurerm_resource_group" "rg" {
    name = "${var.resource_group_name}"
}

resource "azurerm_public_ip" "pip" {
    name                    = "${var.waf_configuration_map["gateway_name"]}-pip"
    resource_group_name     = "${data.azurerm_resource_group.rg.name}"
    location                = "${var.location}"
    allocation_method       = "${var.waf_configuration_map["pip_allocation"]}"
    sku                     = "${var.waf_configuration_map["pip_sku"]}"
}

resource "azurerm_application_gateway" "gw" {
    lifecycle {
        ignore_changes = true
    } 

    name                    = "${var.waf_configuration_map["gateway_name"]}"
    resource_group_name     = "${data.azurerm_resource_group.rg.name}"
    location                = "${var.location}"

    sku {
        name     = "${var.waf_configuration_map["sku_name"]}"
        tier     = "${var.waf_configuration_map["sku_tier"]}"
        capacity = "${var.waf_configuration_map["capacity_sku"]}"
    }

    gateway_ip_configuration {
        name      = "ip-configuration"
        subnet_id = "${var.vnet_id}/subnets/${var.subnet_name}"
    }

    waf_configuration {
        firewall_mode    = "${var.waf_configuration_map["firewall_mode"]}"
        rule_set_type    = "${var.waf_configuration_map["rule_set_type"]}"
        rule_set_version = "${var.waf_configuration_map["rule_set_version"]}"
        enabled          = "${var.waf_configuration_map["waf_enabled"]}"
    }

    

    # ssl_certificate {
    #     name     = "${data.terraform_remote_state.k8s_acs_engine.waf_listener_certificate_name}"
    #     data     = "${base64encode(file("../${data.terraform_remote_state.k8s_acs_engine.waf_listener_certificate_name}.pfx"))}"
    #     password = ""
    # }

    # # for WAF backend pool https
    # authentication_certificate {
    #     name     = "ingress-controller-cert"
    #     data     = "${base64encode(file("../ingress-controller-cert.cer"))}"
    # }

    frontend_port {
        name = "port_80"
        port = "${var.waf_configuration_map["frontend_port"]}"
    }

    frontend_ip_configuration {
        name                        = "public"
        public_ip_address_id        = "${azurerm_public_ip.pip.id}"
    }

    # from now only the nginx ingress controller is exposed from k8s. If another service is exposed, create another backendpool,
    # path_rule and add it to the url_path_map 
    backend_address_pool {
        name            = "backend_address_pool_ingress_controller"
        ip_addresses    = ["${var.internal_ip_ingress}"]
    }

    # Is required and my respond 200 to let the traffic pass. Ingress-controller response on host:80/helthz
    probe {
        name                = "backend_address_pool_ingress_controller_probe"
        host                = "127.0.0.1"
        protocol            = "${var.waf_configuration_map["backend_protocol"]}"
        path                = "/helthz"
        interval            = "5"
        timeout             = "5"
        unhealthy_threshold = "10"
    }

    # port exposed by the ingress controller on k8s
    backend_http_settings {
        name                  = "backend_http_settings_ingress_controller_port_80"
        cookie_based_affinity = "${var.waf_configuration_map["cookie_based_affinity"]}"
        port                  = "${var.waf_configuration_map["backend_port"]}"
        protocol              = "${var.waf_configuration_map["backend_protocol"]}"
        request_timeout       = "${var.waf_configuration_map["request_timeout"]}"
        probe_name            = "backend_address_pool_ingress_controller_probe"
    }

    http_listener {
        name                           = "http"
        frontend_ip_configuration_name = "public"
        frontend_port_name             = "port_80"
        protocol                       = "Http"

    }

    request_routing_rule {
        name                       = "request_routing_rule_ingress_controller"
        rule_type                  = "${var.waf_configuration_map["request_routing_rule_rule_type"]}"
        http_listener_name         = "http"
        backend_address_pool_name  = "backend_address_pool_ingress_controller"
        backend_http_settings_name = "backend_http_settings_ingress_controller_port_80"
    }

}