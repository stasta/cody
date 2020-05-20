# Configure the AWS Provider
provider "aws" {
  version = "2.62"
  region  = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "codyacademic2020-terraform-state"
    key = "wordpress/tf.state"
    region = "us-east-1"
    encrypt = true
  }
}

module "network" {
  source = "./terraform_modules/network"

  vpc_region = "${var.aws_region}"
}

module "security" {
  source = "./terraform_modules/security"

  vpc_id = "${module.network.vpc}"
  whitelisted_ssh_ips = [ "50.68.30.198/32" ]
}

module "web" {
  source = "./terraform_modules/web"

  vpc_id = "${module.network.vpc}"
  subnets_ids = ["${module.network.primary_public_subnet}", "${module.network.secondary_public_subnet}"]

  asg_web_min_size = 0
  asg_web_max_size = 1
  asg_web_des_size = 1

  lc_web_security_groups = ["${module.security.ssh-sg}", "${module.security.web-sg}"]
  alb_sg = "${module.security.web-lb-sg}"
}

module "efs" {
  source = "./terraform_modules/efs"

  subnet1 = "${module.network.primary_public_subnet}"
  subnet2 = "${module.network.secondary_public_subnet}"
  web_server_sg = "${module.security.web-sg}"
}