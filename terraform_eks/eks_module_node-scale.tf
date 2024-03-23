module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.21.0"

  # same as k8s cluster name of vpc tag
  cluster_name = "myapp-eks-cluster"  
  cluster_version = "1.22"

  # grabs from outputs of vpc module
  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }


  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
    }
  }


}

