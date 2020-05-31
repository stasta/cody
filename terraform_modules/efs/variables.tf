variable "vpc_id" {
  type        = "string"
  description = "The VPC where the EFS will be created in."
}

variable "subnets" {
  type        = "list"
  description = "The subnets where the EFS should be available in."
}

variable "primary_subnet" {
  type = "string"
}

variable "secondary_subnet" {
  type = "string"
}

variable "web_sg" {
  type = "string"
}
