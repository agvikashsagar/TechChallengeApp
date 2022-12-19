
resource "aws_security_group" "ecs_security_group" {
  name        = "${var.ecs_cluster_name}-SG"
  description = "Security group for ECS to communicate in and out"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = var.application_port
    to_port     = var.application_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.ecs_cluster_name}-SG"
  }
}


resource "aws_security_group" "ecs_alb_security_group" {
  name        = "${var.ecs_cluster_name}-ALB-SG"
  description = "Security group for ALB to traffic for ECS cluster"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  ingress {
    from_port   = var.application_port
    protocol    = "TCP"
    to_port     = var.application_port
    cidr_blocks = [var.internet_cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.internet_cidr_block]
  }
}

# create security group for RDS
resource "aws_security_group" "rds_sg_group" {
  name = "postgres-public-group"
  description = "access to public rds instances"
  vpc_id = data.terraform_remote_state.infra.outputs.vpc_id


  ingress {
    protocol = "tcp"
    from_port = 5432
    to_port = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 1433
    to_port = 1433
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_alb" "ecs_cluster_alb" {
  name            = "${var.ecs_cluster_name}-ALB"
  internal        = false
  security_groups = [aws_security_group.ecs_alb_security_group.id]
  # subnets         = [split(",", join(",", data.terraform_remote_state.infrastructure.outputs.public_subnets))]
  subnets = [data.terraform_remote_state.infra.outputs.public-subnet-1_id,data.terraform_remote_state.infra.outputs.public-subnet-2_id,data.terraform_remote_state.infra.outputs.public-subnet-3_id]
  tags = {
    Name = "${var.ecs_cluster_name}-ALB"
  }
}

resource "aws_alb_target_group" "app" {
  name        = "${var.ecs_cluster_name}-TG"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
  tags = {

    Name = "${var.ecs_cluster_name}-TG"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.ecs_cluster_alb.id
  port              = var.application_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}

