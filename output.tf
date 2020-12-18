output "wordpress_alb_dns_name" {
  value = "${module.web-ecs.alb_dns_name}"
}

output "db_endpoint" {
  value = "${module.rds.db_endpoint}"
}

output "network_subnets" {
  value = module.network.public_subnets
}
