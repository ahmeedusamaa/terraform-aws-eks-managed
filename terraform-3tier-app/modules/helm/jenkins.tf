resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "jenkins"
  create_namespace = true
  version    = "5.8.55"

  values = [
    templatefile("${path.module}/values/jenkins_values.yaml", {
      domain_name  = var.domain_name
    })
  ]
}


# Create IAM policy for Kaniko ECR access
resource "aws_iam_policy" "kaniko_pod_ecr_policy" {
  name        = "KanikoPodECRPolicy"
  description = "Policy for Kaniko to push images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create IAM role for IRSA (assume by service account)
resource "aws_iam_role" "kaniko_pod_irsa_role" {
  name = "KanikoPodECRRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.cluster_oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:jenkins:kaniko-serviceaccount"
          }
        }
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "kaniko_ecr_attach" {
  role       = aws_iam_role.kaniko_pod_irsa_role.name
  policy_arn = aws_iam_policy.kaniko_pod_ecr_policy.arn
}

# Create Kubernetes service account with the IAM role annotation
resource "kubernetes_service_account" "kaniko_sa" {
  metadata {
    name      = "kaniko-serviceaccount"
    namespace = "jenkins"  

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.kaniko_pod_irsa_role.arn
    }
  }
  depends_on = [ helm_release.jenkins, aws_iam_role_policy_attachment.kaniko_ecr_attach]
}

