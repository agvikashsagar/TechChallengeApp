output "vpc_id" {
  description = "ID of the vpc"
  value       = data.terraform_remote_state.infra.outputs.vpc_id
}

output "alb" {
  value = aws_alb.ecs_cluster_alb.dns_name
}

output "aws_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "aws_ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "security_group_ecs_id" {
  value = aws_security_group.ecs_alb_security_group.id
}

output "aws_alb_target_group_id" {
  value = aws_alb_target_group.app.arn
}

output "aws_alb_listener_id" {
  value = aws_alb_listener.front_end.id
}

output "aws_iam_role_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.ecs_task_execution_role.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "rds_db_endpoint" {
  value = aws_db_instance.rds_instance.address
}