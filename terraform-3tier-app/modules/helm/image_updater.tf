resource "helm_release" "argocd_image_updater" {
  name       = "argocd-image-updater"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  version    = "0.12.2"
  namespace = "argocd"
  values = [
    templatefile("${path.module}/values/image_updater.tpl.yaml", {
      aws_account_id = var.aws_account_id
      aws_region     = var.region
      ecr_front      = var.ecr_front
      ecr_back       = var.ecr_back
    })
  ]
  depends_on = [ helm_release.argo-cd ]
}




resource "aws_iam_policy" "image_updater_ecr_read" {
  name        = "ImageUpdaterECRRead"
  description = "Read-only ECR access for image updater"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage" ,
          "ecr:ListImages" ,
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "image_updater_irsa" {
  name = "ImageUpdaterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.cluster_oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:argocd:argocd-image-updater-sa"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "image_updater_policy_attach" {
  role       = aws_iam_role.image_updater_irsa.name
  policy_arn = aws_iam_policy.image_updater_ecr_read.arn
}


resource "kubernetes_service_account" "image_updater_sa" {
  metadata {
    name      = "argocd-image-updater-sa"
    namespace = "argocd"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.image_updater_irsa.arn
    }
  }
}

