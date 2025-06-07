# Use AWS Secrets Manager to store your secrets.
# Deploy External Secrets Operator (ESO) in EKS.
# Use IRSA (IAM Roles for Service Accounts) to grant ESO access to AWS secrets.
# Create a Kubernetes ExternalSecret that syncs from AWS → Kubernetes.

resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.9.13"

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-secrets-sa"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.eso_irsa.arn
  }


# install all required Custom Resource Definitions (CRDs), including:  #SecretStore  #ClusterSecretStore  #ExternalSecret  #PushSecret
  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "provider.aws.service"
    value = "SecretsManager"
  }
}


resource "aws_iam_policy" "eso_policy" {
  name = "ESOSecretsAccess"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:GetResourcePolicy",
          "kms:Decrypt"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
}

resource "aws_iam_role" "eso_irsa" {
  name = "external-secrets-irsa"
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
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:external-secrets:external-secrets-sa",
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso_irsa.name
  policy_arn = aws_iam_policy.eso_policy.arn
}


# resource "kubectl_manifest" "external_secret_app" {
#   yaml_body  = <<-EOF
# apiVersion: external-secrets.io/v1beta1
# kind: ExternalSecret
# metadata:
#   name: app-secrets  
# spec:
#   refreshInterval: 1h
#   secretStoreRef:
#     name: aws-cluster-secretstore
#     kind: ClusterSecretStore
#   target:
#     name: app-secrets
#     creationPolicy: Owner
#   data:
#     - secretKey: PORT
#       remoteRef:
#         key: app-secrets
#         property: PORT
#     - secretKey: MYSQL_HOST
#       remoteRef:
#         key: app-secrets
#         property: MYSQL_HOST
#     - secretKey: MYSQL_PORT
#       remoteRef:
#         key: app-secrets
#         property: MYSQL_PORT
#     - secretKey: MYSQL_USER
#       remoteRef:
#         key: app-secrets
#         property: MYSQL_USER
#     - secretKey: MYSQL_PASSWORD
#       remoteRef:
#         key: app-secrets
#         property: MYSQL_PASSWORD
#     - secretKey: MYSQL_DATABASE
#       remoteRef:
#         key: app-secrets
#         property: MYSQL_DATABASE
#     - secretKey: REDIS_HOST
#       remoteRef:
#         key: app-secrets
#         property: REDIS_HOST
#     - secretKey: REDIS_PORT
#       remoteRef:
#         key: app-secrets
#         property: REDIS_PORT
#     - secretKey: REDIS_PASSWORD
#       remoteRef:
#         key: app-secrets
#         property: REDIS_PASSWORD
#     - secretKey: JENKINS_USER
#       remoteRef:
#         key: app-secrets
#         property: JENKINS_ADMIN_USERNAME
#     - secretKey: JENKINS_PASSWORD
#       remoteRef:
#         key: app-secrets
#         property: JENKINS_ADMIN_PASSWORD
#     - secretKey: ARGO_ADMIN_ENABLED
#       remoteRef:
#         key: app-secrets
#         property: ARGO_ADMIN_ENABLED
#     - secretKey: ARGO_ADMIN_PASSWORD
#       remoteRef:
#         key: app-secrets
#         property: ARGO_ADMIN_PASSWORD
#     - secretKey: GRAFANA_USER
#       remoteRef:
#         key: app-secrets
#         property: GRAFANA_ADMIN_USER
#     - secretKey: GRAFANA_PASSWORD
#       remoteRef:
#         key: app-secrets
#         property: GRAFANA_ADMIN_PASSWORD
#     - secretKey: SONARQUBE_USER
#       remoteRef:
#         key: app-secrets
#         property: SONARQUBE_ADMIN_USER
#     - secretKey: SONARQUBE_PASSWORD
#       remoteRef:
#         key: app-secrets
#         property: SONARQUBE_ADMIN_PASSWORD
# EOF
#   depends_on = [helm_release.external_secrets, kubectl_manifest.cluster_secretstore]
# }