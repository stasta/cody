variable aws_region {
  type        = "string"
  description = "AWS Region where resources will be deployed."
  default     = "us-east-1"
}

variable "app_name" {
  type        = "string"
  description = "The application's name for this workload."
}

variable "env" {
  type        = "string"
  description = "e.g.: dev/stage/prod."
  default     = "dev"
}

variable "datadog-api-key" {
  type        = "string"
  description = "The Datadog API key."
}

variable "whitelisted_ssh_ips" {
  type        = "list"
  default     = ["50.68.30.198/32"]
  description = "IP's to have SSH access to EC2 instances."
}
