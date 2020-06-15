variable "ecs_aslc_ebs_size" {
  type = "string"
  default = "10"
  description = "The EBS size (GB) of the EC2 running in ECS cluster."
}

variable "ecs_aslc_instance_type" {
  type = "string"
  default = "t2.micro"
  description = "The instance type of the EC2 running in ECS cluster."
}

variable "file_system_id" {
  type = "string"
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC where the RDS instance will be created in."
}

variable "subnets" {
  type        = "list"
  description = "The subnets where the EFS should be available in."
}

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "des_instance_size" {
  description = "Desired number of instances in the cluster"
}

variable "des_web_containers" {
  type = "string"
  default = 1
  description = "Desired number of web containers running."
}

variable "wordpress-ecs-service" {
  type = "string"
  default = "wordpress-ecs-service"
  description = "The Wordpress ECS service's name."
}

variable "ecs_key_pair_name" {
  type = "string"
}

variable "web_sg" {
  type = "string"
}

variable "ssh_sg" {
  type = "string"
}

variable "alb_name" {
  default = "web_alb"
}

variable "alb_sg" {
  type = "string"
}

variable "datadog-api-key" {
  type    = "string"
  default = ""
}

variable "datadog-extra-config" {
  default = "./init"
}

variable "env" {
  type = "string"
  default = ""
  description = "The environment of this workload (e.g.: dev/staging/prod)"
}

variable "app" {
  type = "string"
  default = ""
  description = "The application's name."
}
