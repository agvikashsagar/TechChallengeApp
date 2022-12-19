data "template_file" "vtt_app" {
  template = file("./templates/ecs/vtt_app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    db_endpoint    = data.terraform_remote_state.platform.outputs.rds_db_endpoint
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "vtt-app-task"
  execution_role_arn       = data.terraform_remote_state.platform.outputs.aws_role_arn
  task_role_arn            = data.terraform_remote_state.platform.outputs.aws_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.vtt_app.rendered
}

resource "aws_ecs_service" "main" {
  name            = "cb-service"
  cluster         = data.terraform_remote_state.platform.outputs.ecs_cluster_name
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [data.terraform_remote_state.platform.outputs.security_group_ecs_id]
    subnets          = [data.terraform_remote_state.infra.outputs.private-subnet-1_id,data.terraform_remote_state.infra.outputs.private-subnet-2_id,data.terraform_remote_state.infra.outputs.private-subnet-3_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.platform.outputs.aws_alb_target_group_id
    container_name   = "cb-app"
    container_port   = var.app_port
  }

  #depends_on = [data.terraform_remote_state.infra.outputs.aws_alb_listener_id, data.terraform_remote_state.infra.outputs.aws_iam_role_policy_attachment_id]
}

