provider "aws" {
    region = "eu-west-2" # has three azs
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

# query azs in region
data "aws_availability_zones" "available" {}


module "myapp-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.64.0"

    # give vpc name
    name = "myapp-vpc"


    cidr = var.vpc_cidr_block
    private_subnets = var.private_subnet_cidr_blocks
    public_subnets = var.public_subnet_cidr_blocks

    azs = data.aws_availability_zones.available.names 

    # every subnet has a nat gateway and use single nat gateway for private subnets
    enable_nat_gateway = true
    single_nat_gateway = true

    enable_dns_hostnames = true # get public dns


    # give vpc a tag with k8s cluster name so that k8s cluster controller manager can detect vpc
    tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    }

    # give public subnet elb for cloud loadbalancer
    public_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/elb" = 1 
    }
    private_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/internal-elb" = 1 
    }


}

