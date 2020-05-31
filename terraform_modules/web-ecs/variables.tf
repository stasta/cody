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

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}

variable "ecs_cluster_name" {
  type = "string"
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
  default = ""
}
