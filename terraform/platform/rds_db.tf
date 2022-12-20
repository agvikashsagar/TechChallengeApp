# create the RDS instance
resource "aws_db_instance" "rds_instance" {
  identifier                  = var.rds_identifier
  allocated_storage           = var.rds_allocated_storage
  storage_type                = var.rds_storage_type
  multi_az                    = true
  engine                      = var.rds_engine
  engine_version              = var.rds_engine_version
  instance_class              = var.rds_instance_type
  db_name                     = "database1"
  username                    = var.rds_username
  password                    = var.rds_password

  port                        = var.postgres_db_port
  vpc_security_group_ids      = [aws_security_group.rds_sg_group.id, aws_security_group.ecs_security_group.id]
  # family = "postgres9.6"
  parameter_group_name        = "default.postgres12"
  db_subnet_group_name        = data.terraform_remote_state.infra.outputs.db_subnet_group
  publicly_accessible         = true # true(if required)
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  apply_immediately           = true
  storage_encrypted           = false
  skip_final_snapshot         = true
  final_snapshot_identifier   = var.rds_final_snapshot_identifier
  # deletion_protection = false
  # enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  ## disable backups to create DB faster
  # maintenance_window = "Mon:00:00-Mon:03:00"
  # backup_window      = "03:00-06:00"
  # backup_retention_period = 0

  tags = {
    Name = "flask-postgres-rds"
  }
}

provider "postgresql" {
  host            = aws_db_instance.rds_instance.address
  port            = 1433
  username        = var.rds_username
  password        = var.rds_password
}
# Create App User
resource "postgresql_role" "application_role" {
  name                = "dbuser_role"
  login               = true
  password            = var.rds_password
  encrypted_password  = true
}
# Create Database
resource "postgresql_database" "dev_db" {
  name              = var.rds_database_name
  owner             = var.rds_username
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}