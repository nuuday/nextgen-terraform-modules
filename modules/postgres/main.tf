resource "aws_security_group" "this" {
  name_prefix = "${var.name}-rds"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "cluster-rules" {
  from_port                = module.postgres_db.this_db_instance_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  to_port                  = module.postgres_db.this_db_instance_port
  type                     = "ingress"
  cidr_blocks              = var.cidr_blocks
}

module "postgres_db" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds?ref=v2.18.0"

  identifier                      = var.name
  engine                          = "postgres"
  engine_version                  = var.engine_version
  instance_class                  = var.database_instance_type
  allocated_storage               = var.database_storage_size
  storage_encrypted               = true
  username                        = var.user
  password                        = var.password
  port                            = "5432"
  vpc_security_group_ids          = [aws_security_group.this.id]
  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  backup_retention_period         = var.backup_retention_period
  tags                            = var.tags
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  subnet_ids                      = var.subnet_ids
  family                          = var.family
  major_engine_version            = var.major_engine_version
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  final_snapshot_identifier       = "${var.name}-rds-final-snapshot"
  multi_az                        = var.multi_az
  deletion_protection             = var.deletion_protection
  parameters = [
    {
      name  = "rds.force_ssl"
      value = "1"
      apply_method = "immediate"
    },
    {
      name  = "shared_preload_libraries"
      value = "pg_stat_statements,pgaudit"
      apply_method = "pending-reboot"
    },
    {
      name  = "pgaudit.log_catalog"
      value = "0"
      apply_method = "pending-reboot"
    },
    {
      name  = "pgaudit.log_parameter"
      value = "1"
      apply_method = "pending-reboot"
    },
    {
      name  = "pgaudit.role"
      value = "rds_pgaudit"
      apply_method = "pending-reboot"
    },
    {
      name  = "pgaudit.log"
      value = "all"
      apply_method = "pending-reboot"
    }
  ]
}