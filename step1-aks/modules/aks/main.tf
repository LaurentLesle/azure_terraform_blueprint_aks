
data "azurerm_resource_group" "rg" {
    name = "${var.resource_group_name}"
}

data "azurerm_kubernetes_cluster" "k8s" {
    depends_on          = ["azurerm_kubernetes_cluster.k8s"]
    
    name                = "${local.aks_name}"
    resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

provider "kubernetes" {
    host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
    
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
}

data "kubernetes_service" "nginx-ingress" {
    
    depends_on = ["helm_release.nginx_ingress"]
    
    metadata {
      name = "nginx-ingress-controller"
    }
}

locals {
    aks_name = "${var.prefix}-${var.aks_map["aks_name"]}"
}
