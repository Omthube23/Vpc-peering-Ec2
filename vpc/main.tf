# Create PROD VPC stack
module "prod" {
  source               = "./modules/vpc"
  name                 = "prod"
  vpc_cidr             = var.prod_vpc_cidr
  public_subnet_cidr   = var.prod_public_subnet_cidr
  private_subnet_cidr  = var.prod_private_subnet_cidr
  tags                 = var.tags
}

# Create DEV VPC stack
module "dev" {
  source               = "./modules/vpc"
  name                 = "dev"
  vpc_cidr             = var.dev_vpc_cidr
  public_subnet_cidr   = var.dev_public_subnet_cidr
  private_subnet_cidr  = var.dev_private_subnet_cidr
  tags                 = var.tags
}

# Security groups (SSH open to world; ICMP from peer VPC CIDR)
module "prod_sg" {
  source        = "./modules/security-group"
  name          = "prod-ssh-icmp"
  vpc_id        = module.prod.vpc_id
  allowed_cidrs = [module.dev.vpc_cidr] # ICMP from DEV to PROD
  tags          = var.tags
}

module "dev_sg" {
  source        = "./modules/security-group"
  name          = "dev-ssh-icmp"
  vpc_id        = module.dev.vpc_id
  allowed_cidrs = [module.prod.vpc_cidr] # ICMP from PROD to DEV
  tags          = var.tags
}

# VPC peering with routes both ways
module "prod_dev_peering" {
  source                   = "./modules/vpc-peering"
  name                     = "prod-to-dev-peering"
  requester_vpc_id         = module.prod.vpc_id
  accepter_vpc_id          = module.dev.vpc_id
  requester_cidr           = module.prod.vpc_cidr
  accepter_cidr            = module.dev.vpc_cidr
  requester_route_tables   = module.prod.route_tables_map
  accepter_route_tables    = module.dev.route_tables_map
  auto_accept              = true
  tags                     = var.tags
}
