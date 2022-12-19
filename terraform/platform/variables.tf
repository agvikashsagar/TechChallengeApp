
variable "ecs_cluster_name" {
  default = "ECS-Cluster"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "internet_cidr_block"{
  default  = "0.0.0.0/0"
}

variable "application_port" {
  default = "3000"
}

variable "vpc_id_infra" {
  default = ""
}

variable "health_check_path" {
  default = "/"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}


variable "rt_wide_route" {
  description = "Route in the SiteSeer Route Table"
  default     = "0.0.0.0/0"
}

variable "postgres_db_port" {
  description = "Port exposed by the RDS instance"
  default = 5432
}
variable "rds_instance_type" {
  description = "Instance type for the RDS database"
  default = "db.t2.micro"
}
# Change database-1 to postgres
variable "rds_identifier" {
  description = "db identifier"
  default     = "app"
}
variable "rds_storage_type" {
  description = "db storage type"
  default     = "gp2"
}
# Change 20 to 5
variable "rds_allocated_storage" {
  description = "db allocated storage"
  default     = 20
}
variable "rds_engine" {
  description = "type of db engine"
  default     = "postgres"
}
variable "rds_engine_version" {
  description = "db engine version"
  default     = "12"
}
variable "rds_database_name" {
  description = "db worker name"
  default     = "app"
}
variable "rds_username" {
  description = "db username"
  default     = "postgres"
}
variable "rds_password" {
  description = "db password"
  default     = "changeme"
}


variable "rds_final_snapshot_identifier" {
  description = "db final snapshot identifier"
  default     = "worker-final"
}