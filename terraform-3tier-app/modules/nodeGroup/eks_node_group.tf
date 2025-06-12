# EC2 Node Group for system workloads
resource "aws_eks_node_group" "system" {
  cluster_name    = var.cluster_name
  node_group_name = "system"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.private_subnets
  version = "1.33" 

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.large"]

  update_config {
    max_unavailable = 1
  }

  # remote_access {
  #   ec2_ssh_key = var.ssh_key_name
  #   source_security_group_ids = [var.eks_node_group_sg_id]
  # }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]


  # Use case: When your autoscaling group or EKS node group desired_size is changed outside of Terraform (for example, by a Kubernetes Cluster Autoscaler or manually in AWS Console), you don't want Terraform to overwrite or try to revert it back.
  # It prevents Terraform from detecting the desired_size as a difference and trying to enforce whatever value is in the Terraform code.
  # Keeps Terraform from unnecessary updates caused by external changes.
  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  # You can use them in node selectors, affinity rules, or taints/tolerations to control where pods run.
  labels = {
    role = "system"
  }
}


