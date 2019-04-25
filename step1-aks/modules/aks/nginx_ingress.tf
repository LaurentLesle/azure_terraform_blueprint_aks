
resource "helm_release" "nginx_ingress" {
    name       = "nginx-ingress"
    chart      = "stable/nginx-ingress"

    # Expose nginx as an internal load balancer. This ip will be the backend pool of the application gateway
    values = [<<EOF
    controller:
        service:
            annotations: {
            service.beta.kubernetes.io/azure-load-balancer-internal: "true"
    }
    EOF
    ]

}

