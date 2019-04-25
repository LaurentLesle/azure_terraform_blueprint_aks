# # https://medium.com/devopslinks/creating-an-azure-kubernetes-service-cluster-with-custom-vnet-helm-and-https-ingress-controller-400d0a3c101
# # https://github.com/Azure/application-gateway-kubernetes-ingress
# # https://github.com/fbeltrao/aks-letsencrypt/blob/master/install-nginx-ingress.md

# data "helm_repository" "azure_samples" {
#     depends_on          = ["azurerm_kubernetes_cluster.k8s"]

#     name = "azure-samples"
#     url  = "https://azure-samples.github.io/helm-charts/"
# }

# resource "helm_release" "hello_world" {
#     name          = "hello-world"
#     chart         = "azure-samples/aks-helloworld"
#     force_update  = true

#     set {
#       name = "serviceName"
#       value = "hello-world"
#     }

#     values = [<<EOF
# apiVersion: extensions/v1beta1
# kind: Ingress
# metadata:
#   name: helloworld
#   annotations:
#     kubernetes.io/ingress.class: nginx
# spec:
#   rules:
#   - host: helloworld.${var.default_dns_name}
#     http:
#       paths:
#       - path: /
#         backend:
#           serviceName: hello-world
#           servicePort: 80
#     EOF
#     ]

# }


