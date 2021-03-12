module "redis_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name = "allow-redis-${var.name}"
  description = "allows access to redis cluster"
  vpc_id = var.vpc_id

  egress_with_self = [
    {
      rule = "all-all"
    },
  ]

  computed_ingress_with_cidr_blocks = [
    {
      rule = "redis-tcp",
      cidr_blocks = var.source_subnet
    },
  ]
  number_of_computed_ingress_with_cidr_blocks = 1
}

resource "aws_elasticache_subnet_group" "this" {
  name = "${var.name}-${var.engine}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = var.name
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.number_of_nodes
  parameter_group_name = var.parameter_group
  engine_version       = var.engine_version
  port                 = 6379
  tags                 = var.tags
  security_group_ids   = [module.redis_security_group.this_security_group_id]
  subnet_group_name    = aws_elasticache_subnet_group.this.name
}

