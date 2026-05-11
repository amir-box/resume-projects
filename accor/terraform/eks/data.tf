data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "company-prod-terraform-state"
    key    = var.network_state_key
    region = "ap-southeast-1"
  }
}