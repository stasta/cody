/*
* This Terraform module creates a Wordpress application in AWS with the following modules:
* - Network: VPC with 2 public subnets for redundancy.
* - Security: Basic security groups required by the application.
* - RDS: RDS Database where Wordpress will store its data.
* - EFS: Elastic File System that persists the local files written by Wordpress application.
* - Web: Application Load Balancer, target group, ECS Cluster, ECS Services, and the ECS Task Definition.
*/

# Configure the AWS Provider
provider "aws" {
  version = "2.62"
  region  = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket  = "codyacademic2020-terraform-state"
    key     = "wordpress/tf.state"
    region  = "us-east-1"
    encrypt = true
  }
}

module "network" {
  source = "./terraform_modules/network"

  region = "${var.aws_region}"
}

module "security" {
  source = "./terraform_modules/security"

  vpc_id              = "${module.network.vpc}"
  whitelisted_ssh_ips = ["${var.whitelisted_ssh_ips}"]
}

module "rds" {
  source = "./terraform_modules/rds"

  vpc_id          = "${module.network.vpc}"
  subnets         = "${module.network.public_subnets}"
  allowed-sgs     = "${module.security.web-sg}"
  whitelisted_ips = ["50.68.30.198/32", "0.0.0.0/0"]
}

/*module "web" {
  source = "./terraform_modules/web"

  keypair_name="${module.security.keypair_name}"

  vpc_id = "${module.network.vpc}"
  subnets_ids = ["${module.network.primary_public_subnet}", "${module.network.secondary_public_subnet}"]

  asg_web_min_size = 0
  asg_web_max_size = 0
  asg_web_des_size = 0

  lc_web_security_groups = ["${module.security.ssh-sg}", "${module.security.web-sg}"]
  alb_sg = "${module.security.web-lb-sg}"
}*/

module "efs" {
  source = "./terraform_modules/efs"

  vpc_id      = "${module.network.vpc}"
  subnets     = "${module.network.public_subnets}"
  allowed-sgs = ["${module.security.web-sg}"]
}

module "web-ecs" {
  source = "./terraform_modules/web-ecs"

  vpc_id         = "${module.network.vpc}"
  subnets        = "${module.network.public_subnets}"
  file_system_id = "${module.efs.file_system}"

  ecs_key_pair_name = "${module.security.keypair_name}"
  web_sg            = "${module.security.web-sg}"
  ssh_sg            = "${module.security.ssh-sg}"

  max_instance_size = 3
  min_instance_size = 1
  des_instance_size = 1

  des_web_containers = 2

  alb_sg          = "${module.security.web-lb-sg}"
  datadog-api-key = "${var.datadog-api-key}"
  env             = "${var.env}"
  app             = "${var.app_name}"
}

//TODO add cloudfront

