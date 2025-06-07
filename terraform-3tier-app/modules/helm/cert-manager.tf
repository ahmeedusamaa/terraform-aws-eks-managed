resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true
  version    = "1.17.2"

  values = [
    templatefile("${path.module}/values/cert_manager.yaml", {
      cluster_name = var.cluster_name
      region       = var.region
    })
  ]
  depends_on = [
    helm_release.nginx_ingress
  ]
  
}
