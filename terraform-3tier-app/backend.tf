# terraform {
#   backend "s3" {
#     bucket       = "bucket-terraform-state-3"
#     region       = "ap-south-1"
#     key          = "terraform.tfstate"
#     encrypt      = true
#     use_lockfile = true
#   }
# }


terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
