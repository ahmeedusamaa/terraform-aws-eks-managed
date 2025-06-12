resource "helm_release" "argo-cd" {
    name       = "argo-cd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    namespace  = "argocd"
    create_namespace = true
    version    = "8.0.14"
    
  values = [
    templatefile("${path.module}/values/argocd_values.yaml", {
      domain_name  = var.domain_name
    })
  ]

  depends_on = [ helm_release.nginx_ingress ]
} 

