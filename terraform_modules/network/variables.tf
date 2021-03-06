variable "vpc_name" {
  type        = "string"
  description = "The VPC to be created with public subnets."
  default     = "main_vpc"
}

variable "region" {
  type        = "string"
  description = "AWS Region where resources will be deployed."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "The CIDR block to use in the VPC."
  default     = "10.0.0.0/16"
}

variable "subnets_cidr_block" {
  type        = "list"
  description = "List of subnet's CIDR blocks."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
