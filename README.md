This Terraform module creates a Wordpress application in AWS with the following modules:
- Network: VPC with 2 public subnets for redundancy.
- Security: Basic security groups required by the application.
- RDS: RDS Database where Wordpress will store its data.
- EFS: Elastic File System that persists the local files written by Wordpress application.
- Web: Application Load Balancer, target group, ECS Cluster, ECS Services, and the ECS Task Definition.

## Requirements

| Name | Version |
|------|---------|
| aws | 2.62 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_name | The application's name for this workload | `string` | `"wordpress"` | no |
| aws\_region | AWS Region where resources will be deployed | `string` | `"us-east-1"` | no |
| datadog-api-key | The Datadog API key. | `string` | n/a | yes |
| env | e.g.: dev/stage/prod | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| db\_endpoint | n/a |
| wordpress\_alb\_dns\_name | n/a |

