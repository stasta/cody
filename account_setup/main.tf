# Configure the AWS Provider
provider "aws" {
  version = "2.62"
  region  = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "codyacademic2020-terraform-state"
    key = "account_setup/tf.state"
    region = "us-east-1"
    encrypt = true
  }
}

module "iam" {
  source = "../terraform_modules/iam/"

  account_alias = "codyacademic2020"
  administrator_users = ["gustavo.fernandes"]
}