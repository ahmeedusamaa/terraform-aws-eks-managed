# OIDC Provider for EKS
data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}


# EKS has an OIDC provider — trusted token issuer.
# When a pod runs with a Kubernetes service account, Kubernetes automatically gives that pod a special token (an OIDC token).
# This token is stored inside the pod (mounted as a file).
# The token proves the pod’s identity when talking to AWS.
# AWS trusts the EKS OIDC provider and uses this token to decide if the pod can assume an IAM role and get permissions.
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  # this is the OIDC endpoint that will issue identity tokens for service accounts inside my EKS cluster
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
