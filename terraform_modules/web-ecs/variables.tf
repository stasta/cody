variable "file_system_id" {
  type = "string"
}

variable "primary_subnet" {
  type = "string"
}

variable "secondary_subnet" {
  type = "string"
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

variable "vpc_id" {
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
