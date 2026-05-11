provider "aws" {
  alias  = "primary"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "secondary"
  region = "ap-northeast-1"
}