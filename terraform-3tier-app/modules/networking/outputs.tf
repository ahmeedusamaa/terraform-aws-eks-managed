output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
  
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "database_subnet_group" {
  description = "The name of the database subnet group"
  value       = aws_db_subnet_group.database.name
  
}