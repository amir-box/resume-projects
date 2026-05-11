region = "ap-southeast-1"

name = "prod-singapore"

vpc_cidr = "10.10.0.0/16"

azs = [
  "ap-southeast-1a",
  "ap-southeast-1b"
]

public_subnets = [
  "10.10.1.0/24",
  "10.10.2.0/24"
]

private_subnets = [
  "10.10.11.0/24",
  "10.10.12.0/24"
]

database_subnets = [
  "10.10.21.0/24",
  "10.10.22.0/24"
]