resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
  }
}


resource "null_resource" "apply_k8s_manifest" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./argocd-app/"
  }
  depends_on = [ helm_release.argo-cd, helm_release.argocd_image_updater,  helm_release.nginx_ingress, helm_release.kube-prometheus-stack  ,null_resource.update_kubeconfig ]
}
