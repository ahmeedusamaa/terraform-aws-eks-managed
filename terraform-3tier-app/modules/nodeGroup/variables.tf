variable "private_subnets" {
  description = "List of private subnet IDs for the node group"
  type        = list(string)
} 

variable "public_subnets" {
  description = "List of public subnet IDs for the EKS cluster and node groups"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "URL of the EKS cluster's OIDC issuer"
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "ARN of the EKS cluster's OIDC provider"
  type        = string
}