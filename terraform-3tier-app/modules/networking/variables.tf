variable "vpc_cidr" {
 type        = string
 description = "VPC CIDR value"
 default     = "10.0.0.0/16"

}


variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"

}

 

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"

}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-south-1a", "ap-south-1b"]

}