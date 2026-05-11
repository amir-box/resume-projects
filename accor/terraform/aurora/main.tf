resource "aws_rds_global_cluster" "this" {
  global_cluster_identifier = "prod-global"

  engine         = "aurora-postgresql"
  engine_version = "16.4"

  storage_encrypted = true

  deletion_protection = true
}

module "aurora_primary" {
  providers = {
    aws = aws.primary
  }

  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "10.2.0"

  name = "prod-primary"

  engine         = "aurora-postgresql"
  engine_version = "16.4"

  global_cluster_identifier = aws_rds_global_cluster.this.id

  master_username = "postgres"

  manage_master_user_password = true

  instance_class = "db.r7g.large"

  instances = {
    writer = {}
    reader1 = {}
  }

  vpc_id = data.terraform_remote_state.network.outputs.primary_vpc_id

  create_db_subnet_group = true

  subnets = data.terraform_remote_state.network.outputs.primary_database_subnets


  storage_encrypted = true

  deletion_protection = true

  performance_insights_enabled = true

  monitoring_interval = 60

  enabled_cloudwatch_logs_exports = [
    "postgresql"
  ]
}




module "aurora_secondary" {
  providers = {
    aws = aws.secondary
  }

  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "10.2.0"

  name = "prod-secondary"

  engine         = "aurora-postgresql"
  engine_version = "16.4"

  global_cluster_identifier = aws_rds_global_cluster.this.id

  is_primary_cluster = false

  instance_class = "db.r7g.large"

  instances = {
    reader1 = {}
  }

  vpc_id = data.terraform_remote_state.network.outputs.secondary_vpc_id

  create_db_subnet_group = true

  subnets = data.terraform_remote_state.network.outputs.secondary_database_subnets

  storage_encrypted = true

  deletion_protection = true
}






