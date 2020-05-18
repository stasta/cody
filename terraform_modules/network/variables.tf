variable "vpc_name" { default = "main_vpc" }
variable "vpc_region" { type = "string" }

variable "vpc_cidr_block" { default = "10.0.0.0/16" }
variable "subnet_cidr_block" {
  type = "map"
  default = {
    primary_public = "10.0.1.0/24"
    secondary_public = "10.0.2.0/24"
  }
}
