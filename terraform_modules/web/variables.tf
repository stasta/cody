variable "vpc_id" { type = "string" }
variable "subnets_ids" { type = "list" }

variable "lc_web_name_prefix" { default = "lc-web-" }
variable "lc_web_instance_type" { default = "t2.micro" }
variable "lc_web_security_groups" { type = "list" }

variable "asg_web_name_prefix" { default = "asg-web-" }
variable "asg_web_ec2_tag_name" { default = "webserver" }
variable "asg_web_min_size" { default = 0 }
variable "asg_web_max_size" { default = 0 }
variable "asg_web_des_size" { default = 0 }

variable "alb_name" { default = "web_alb" }
variable "alb_sg" { type = "string" }