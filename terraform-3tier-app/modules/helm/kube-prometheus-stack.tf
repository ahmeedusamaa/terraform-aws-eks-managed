resource "helm_release" "kube-prometheus-stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  version          = "72.9.0"

  values = [
    templatefile("${path.module}/values/kube-prometheus-stack.yaml", {
      domain_name  = var.domain_name
    })
  ]
}
