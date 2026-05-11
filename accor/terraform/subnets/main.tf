module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = var.name
  cidr = var.vpc_cidr

  azs = var.azs

  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group = true
}