# Configure the AWS Provider
provider "aws" {
  version = "2.62"
  region  = "${var.aws_region}"
}

module "iam" {
  source = "./terraform_modules/iam/"
}