output "node_group_id" {
  description = "The ID of the node group."
  value       = aws_eks_node_group.system.id
  
}

output "ebs_csi_controller_role_arn" {
  description = "ARN of the EBS CSI controller IAM role"
  value       = aws_iam_role.ebs_csi_controller.arn
}

output "ebs_csi_controller_policy_attachment" {
  description = "The EBS CSI controller policy attachment resource"
  value       = aws_iam_role_policy_attachment.ebs_csi_controller_policy
} 