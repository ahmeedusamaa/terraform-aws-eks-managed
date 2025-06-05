output "ecr_front" {
  description = "The name of the front ECR repository."
  value       = aws_ecr_repository.ecr-front.name
  
}

output "ecr_back" {
  description = "The name of the back ECR repository."
  value       = aws_ecr_repository.ecr-back.name
  
}
