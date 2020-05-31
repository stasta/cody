variable aws_region {
  type        = "string"
  description = "AWS Region where resources will be deployed."
  default     = "us-east-1"
}

variable "app_name" {
  type        = "string"
  description = "The application's name for this workload."
  default     = "wordpress"
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
