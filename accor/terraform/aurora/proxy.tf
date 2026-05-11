resource "aws_iam_role" "rds_proxy" {
  name = "prod-rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "rds.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "rds_proxy" {
  name = "prod-rds-proxy-policy"

  role = aws_iam_role.rds_proxy.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "secretsmanager:GetSecretValue"
      ]

      Resource = "*"
    }]
  })
}


resource "aws_db_proxy" "primary" {
  provider = aws.primary

  name                   = "prod-primary-proxy"
  engine_family          = "POSTGRESQL"

  role_arn = aws_iam_role.rds_proxy.arn

  vpc_subnet_ids = data.terraform_remote_state.network.outputs.primary_database_subnets

  vpc_security_group_ids = [
    module.aurora_primary.security_group_id
  ]

  idle_client_timeout = 1800

  require_tls = true

  auth {
    auth_scheme = "SECRETS"

    iam_auth = "DISABLED"

    secret_arn = module.aurora_primary.cluster_master_user_secret[0].secret_arn
  }
}

resource "aws_db_proxy_default_target_group" "primary" {
  provider = aws.primary

  db_proxy_name = aws_db_proxy.primary.name

  connection_pool_config {
    max_connections_percent      = 90
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "primary" {
  provider = aws.primary

  db_proxy_name = aws_db_proxy.primary.name

  target_group_name = aws_db_proxy_default_target_group.primary.name

  db_cluster_identifier = module.aurora_primary.cluster_id
}


resource "aws_db_proxy" "secondary" {
  provider = aws.secondary

  name          = "prod-secondary-proxy"
  engine_family = "POSTGRESQL"

  role_arn = aws_iam_role.rds_proxy.arn

  vpc_subnet_ids = data.terraform_remote_state.network.outputs.secondary_database_subnets

  vpc_security_group_ids = [
    module.aurora_secondary.security_group_id
  ]

  require_tls = true

  auth {
    auth_scheme = "SECRETS"

    iam_auth = "DISABLED"

    secret_arn = module.aurora_primary.cluster_master_user_secret[0].secret_arn
  }
}

resource "aws_db_proxy_default_target_group" "secondary" {
  provider = aws.secondary

  db_proxy_name = aws_db_proxy.secondary.name
}

resource "aws_db_proxy_target" "secondary" {
  provider = aws.secondary

  db_proxy_name = aws_db_proxy.secondary.name

  target_group_name = aws_db_proxy_default_target_group.secondary.name

  db_cluster_identifier = module.aurora_secondary.cluster_id
}