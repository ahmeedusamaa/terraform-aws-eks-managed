variable "vpc_cidr" {
 type        = string
 description = "VPC CIDR value"
  
}

variable "public_key" {
  description = "Name of the EC2 key pair"
  type        = string
  
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

 

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "admin"
  
}

variable "domain_name" {
  description = "Your root domain name (e.g. example.com)"
  type        = string
  
}

variable "aws_account_id" {
  description = "The AWS account ID where the EKS cluster is located."
  type        = string
  
}


variable "mysql_user" {
  description = "MySQL user"
  type        = string
}

variable "mysql_password" {
  description = "MySQL password"
  type        = string
}

variable "mysql_database" {
  description = "MySQL database name"
  type        = string
}

variable "mysql_root_password" {
  description = "MySQL root password"
  type        = string
  sensitive   = true
}

variable "mysql_host" {
  description = "MySQL host"
  type        = string
}

variable "mysql_port" {
  description = "MySQL port"
  type        = string
}

variable "redis_host" {
  description = "Redis host"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = string
}

variable "redis_password" {
  description = "Redis password"
  type        = string
}

variable "github-credentials" {
  description = "GitHub credentials for accessing private repositories"
  type        = string
  sensitive   = true
  
}