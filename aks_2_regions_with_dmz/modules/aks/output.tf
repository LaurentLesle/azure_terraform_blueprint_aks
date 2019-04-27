output "nginx-ingress_loadbalancer_ip" {
  value = "${data.kubernetes_service.nginx-ingress.load_balancer_ingress.0.ip}"
}