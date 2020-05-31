variable "vpc_id" {
  type        = "string"
  description = "The VPC where the RDS instance will be created in."
}

variable "subnets" {
  type        = "list"
  description = "The subnets where the EFS should be available in."
}

variable "allowed-sgs" {
  type        = "string"
  description = "List of Security Group ID's that have access to the RDS instance"
}
