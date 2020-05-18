# Configure the AWS Provider
provider "aws" {
  version = "2.62"
  region  = "${var.aws_region}"
}

//terraform {
//  backend "s3" {
//    bucket = "${module.s3.remote-state-bucket-name}"
//  }
//}

module "iam" {
  source = "./terraform_modules/iam/"

  account_alias = "codyacademic2020"
  administrator_users = ["gustavo.fernandes"]
}

module "s3" {
  source = "./terraform_modules/s3/"

  account_alias = "${module.iam.account_alias}"
}