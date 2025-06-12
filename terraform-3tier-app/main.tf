module "eks" {
  source = "./modules/eks"
  public_subnets = module.networking.public_subnet_ids
  private_subnets = module.networking.private_subnet_ids
}

module "nodeGroups" {
  source = "./modules/nodeGroup"
  cluster_name = module.eks.eks_cluster_name
  public_subnets = module.networking.public_subnet_ids
  private_subnets = module.networking.private_subnet_ids
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  cluster_oidc_provider_arn = module.eks.cluster_oidc_provider_arn
}

module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs = var.azs
}

module "helm" {
  source = "./modules/helm"
  cluster_name = module.eks.eks_cluster_name
  region = var.region
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  cluster_oidc_provider_arn = module.eks.cluster_oidc_provider_arn
  ecr_front = module.ECR.ecr_front
  ecr_back = module.ECR.ecr_back
  aws_account_id = var.aws_account_id
  depends_on = [ module.eks , module.nodeGroups, module.kubernetes ] 
  domain_name = var.domain_name
}

module "secrets" {
  source = "./modules/secrets"
  mysql_user = var.mysql_user
  mysql_password = var.mysql_password
  mysql_root_password = var.mysql_root_password
  mysql_database = var.mysql_database
  mysql_host = var.mysql_host
  mysql_port = var.mysql_port
  redis_host = var.redis_host
  redis_port = var.redis_port
  redis_password = var.redis_password
  
}

module "ECR" {
  source = "./modules/ECR"
  eks_cluster_name = module.eks.eks_cluster_name
}

module "Route53" {
  source = "./modules/route53"
  domain_name = var.domain_name
  depends_on = [ module.eks , module.helm ]
}

module "kubernetes" {
  source = "./modules/kubernetes"
  depends_on = [ module.eks , module.nodeGroups ]
}