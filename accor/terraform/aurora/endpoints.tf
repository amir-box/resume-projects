module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  security_group_ids = [
    aws_security_group.vpce.id
  ]

  endpoints = {
    ecr_api = {
      service             = "ecr.api"
      subnet_ids          = module.vpc.database_subnets
      private_dns_enabled = true
    }

    ecr_dkr = {
      service             = "ecr.dkr"
      subnet_ids          = module.vpc.database_subnets
      private_dns_enabled = true
    }

    sqs = {
      service             = "sqs"
      subnet_ids          = module.vpc.database_subnets
      private_dns_enabled = true
    }

    logs = {
      service             = "logs"
      subnet_ids          = module.vpc.database_subnets
      private_dns_enabled = true
    }

    secretsmanager = {
      service             = "secretsmanager"
      subnet_ids          = module.vpc.database_subnets
      private_dns_enabled = true
    }

    aps = {
      service             = "aps-workspaces"
      subnet_ids          = module.vpc.database_subnets
      private_dns_enabled = true
    }

    s3 = {
      service      = "s3"
      service_type = "Gateway"

      route_table_ids = concat(
        module.vpc.private_route_table_ids,
        module.vpc.database_route_table_ids
      )
    }
  }
}