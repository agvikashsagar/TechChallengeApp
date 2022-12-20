variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "public.ecr.aws/l8x4m3e8/vtt_app:latest"
}

variable "db_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "postgres"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "db_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 5432
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "database_count" {
  description = "Number of docker containers to run"
  default     = 0
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}


variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

