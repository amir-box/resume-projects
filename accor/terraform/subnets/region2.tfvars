region = "ap-northeast-1"

name = "prod-tokyo"

vpc_cidr = "10.20.0.0/16"

azs = [
  "ap-northeast-1a",
  "ap-northeast-1c"
]

public_subnets = [
  "10.20.1.0/24",
  "10.20.2.0/24"
]

private_subnets = [
  "10.20.11.0/24",
  "10.20.12.0/24"
]

database_subnets = [
  "10.20.21.0/24",
  "10.20.22.0/24"
]