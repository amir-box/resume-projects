data "terraform_remote_state" "singapore" {
  backend = "s3"

  config = {
    bucket = "company-prod-terraform-state"

    key = "prod/network/singapore.tfstate"

    region = "ap-southeast-1"
  }
}

data "terraform_remote_state" "tokyo" {
  backend = "s3"

  config = {
    bucket = "company-prod-terraform-state"

    key = "prod/network/tokyo.tfstate"

    region = "ap-southeast-1"
  }
}