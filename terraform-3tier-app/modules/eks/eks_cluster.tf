resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.33"

  vpc_config {
    # (true) -> The Kubernetes API server is only accessible via private IPs inside the VPC
    endpoint_private_access = true
    # (false) -> The API server is not accessible over the internet (no public IP)
    endpoint_public_access  = true
    subnet_ids = var.private_subnets
  }

  # access to the cluster control plane API
  # allow the identity that created the EKS cluster (via Terraform) to automatically gain Kubernetes cluster-admin access in the cluster's RBAC,
  # The identity that Terraform uses to create the EKS cluster is the IAM identity configured in your AWS CLI
  access_config {
    authentication_mode = "API"
    #  to deploy Helm charts 
    bootstrap_cluster_creator_admin_permissions = true
  }

  # bootstrap_self_managed_addons = true

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}