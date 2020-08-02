output "alb_dns_name" {
  value = "${aws_lb.web_alb.dns_name}"
}

output "web_tg_arn" {
  value = "${aws_lb_target_group.web-target-group.arn}"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.wordpress-ecs-cluster.name}"
}
