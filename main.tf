
provider "aws" {
  region = var.region
}

# ── VPC stack (creates both VPCs, subnets, SGs, peering) ─────────────
module "vpc" {
  source = "./vpc"

  # Inputs (defaults exist; override here if you want)
  prod_vpc_cidr            = "10.0.0.0/16"
  prod_public_subnet_cidr  = "10.0.1.0/24"
  prod_private_subnet_cidr = "10.0.2.0/24"

  dev_vpc_cidr             = "10.1.0.0/16"
  dev_public_subnet_cidr   = "10.1.1.0/24"
  dev_private_subnet_cidr  = "10.1.2.0/24"

  tags = var.tags
}

# ── EC2 in PROD ──────────────────────────────────────────────────────
module "prod_ec2" {
  source             = "./ec2"
  name               = "prod-ec2"
  subnet_id          = module.vpc.prod_public_subnet_id
  security_group_ids = [module.vpc.prod_sg_id]
  instance_type      = "t3.medium"
  key_name           = "pem"
  tags               = var.tags
  depends_on         = [module.vpc]
}

# ── EC2 in DEV ───────────────────────────────────────────────────────
module "dev_ec2" {
  source             = "./ec2"
  name               = "dev-ec2"
  subnet_id          = module.vpc.dev_public_subnet_id
  security_group_ids = [module.vpc.dev_sg_id]
  instance_type      = "t3.medium"
  key_name           = "pem"
  tags               = var.tags
  depends_on         = [module.vpc]
}

# ── Outputs ──────────────────────────────────────────────────────────
output "prod_ec2_public_ip" { value = module.prod_ec2.public_ip }
output "dev_ec2_public_ip"  { value = module.dev_ec2.public_ip }
output "prod_ec2_private_ip" { value = module.prod_ec2.private_ip }
output "dev_ec2_private_ip"  { value = module.dev_ec2.private_ip }
