# Get the Route53 hosted zone
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}


# Jenkins DNS record
resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "jenkins-server.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname]
  }

# Prometheus DNS record
resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "prometheus-server.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname]
  }

# ArgoCD DNS record
resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "argocd-server.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname]
  }

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "ahmed.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname]
  }

