variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster and node groups"
  type        = list(string)
} 

variable "public_subnets" {
  description = "List of public subnet IDs for the EKS cluster and node groups"
  type        = list(string)
}
