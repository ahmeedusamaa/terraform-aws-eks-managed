variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  
}

variable "region" {
  description = "The AWS region where the EKS cluster is located."
  type        = string
  
}

variable "domain_name" {
  description = "Your root domain name (e.g. example.com)"
  type        = string
}


variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster."
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "The ARN of the OIDC provider for the EKS cluster."
  type        = string
} 

variable "aws_account_id" {
  description = "The AWS account ID where the EKS cluster is located."
  type        = string
}

variable "ecr_back" {
  description = "The name of the ECR back repository to be used by the image updater."
  type        = string
  
}

variable "ecr_front" {
  description = "The name of the ECR front repository to be used by the image updater."
  type        = string
  
}