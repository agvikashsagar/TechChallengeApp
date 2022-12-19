data "template_file" "vtt_database" {
  template = file("./templates/ecs/vtt_database.json.tpl")

  vars = {
    db_image      = var.db_image
    db_port       = var.db_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "database" {
  family                   = "vtt-database-task"
  execution_role_arn       = data.terraform_remote_state.platform.outputs.aws_role_arn
  task_role_arn            = data.terraform_remote_state.platform.outputs.aws_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.vtt_database.rendered
}

resource "aws_ecs_service" "main-db" {
  name            = "database-service"
  cluster         = data.terraform_remote_state.platform.outputs.ecs_cluster_name
  task_definition = aws_ecs_task_definition.database.arn
  desired_count   = var.database_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [data.terraform_remote_state.platform.outputs.security_group_ecs_id]
    subnets          = [data.terraform_remote_state.infra.outputs.private-subnet-1_id,data.terraform_remote_state.infra.outputs.private-subnet-2_id,data.terraform_remote_state.infra.outputs.private-subnet-3_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.platform.outputs.aws_alb_target_group_id
    container_name   = "cb-database"
    container_port   = var.db_port
  }

  #depends_on = [data.terraform_remote_state.infra.outputs.aws_alb_listener_id, data.terraform_remote_state.infra.outputs.aws_iam_role_policy_attachment_id]
}

