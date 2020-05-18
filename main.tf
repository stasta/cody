# Configure the AWS Provider
provider "aws" {
  version = "2.62"
  region  = "${var.aws_region}"
}

module "iam" {
  source = "./terraform_modules/iam/"

  account_alias = "codyacademic2020"
  administrator_users = ["gustavo.fernandes"]
}