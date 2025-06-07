resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true
  version    = "4.0.13"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer" # Creates an AWS Load Balancer
  }
}

