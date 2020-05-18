# Configure the AWS Provider
provider "aws" {
  version = "2.62"
  region  = "${var.aws_region}"
}

# Create the S3 bucket first before setting the backend.
# See the ./terraform_modules/remote-state/README.md.
terraform {
  backend "s3" {
    bucket = "codyacademic2020-terraform-state"
    key = "tf-state-codyacademic2020"
    region = "us-east-1"
    encrypt = true
  }
}

module "iam" {
  source = "./terraform_modules/iam/"

  account_alias = "codyacademic2020"
  administrator_users = ["gustavo.fernandes"]
}

module "s3" {
  source = "./terraform_modules/remote-state/"

  account_alias = "${module.iam.account_alias}"
}

module "network" {
  source = "./terraform_modules/network"

  vpc_region = "${var.aws_region}"
  whitelisted_ips = [ "" ]
}