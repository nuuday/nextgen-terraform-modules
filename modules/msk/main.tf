

module "kafka_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name = "allow-kafka-${var.cluster_name}"
  description = "allows access to kafka brokers"
  vpc_id = var.vpc_id

  egress_with_self = [
    {
      rule = "all-all"
    },
  ]

  # allow EKS workloads to access kafka
  computed_ingress_with_cidr_blocks = [
    {
      rule = "kafka-broker-tcp",
      cidr_blocks = var.source_subnet
    },
    {
      rule = "kafka-broker-tls-tcp",
      cidr_blocks = var.source_subnet
    },
    {
      rule = "zookeeper-2181-tcp",
      cidr_blocks = var.source_subnet
    },
  ]
  number_of_computed_ingress_with_cidr_blocks = 3
}

resource "aws_msk_cluster" "this" {
  cluster_name = var.cluster_name
  kafka_version = var.kafka_version
  number_of_broker_nodes = var.number_of_brokers
  broker_node_group_info {
    client_subnets = var.number_of_brokers < length(var.subnet_ids) ? slice(var.subnet_ids, 0, var.number_of_brokers) : var.subnet_ids
    ebs_volume_size = var.ebs_volume_size
    instance_type = var.instance_size
    security_groups = [module.kafka_security_group.this_security_group_id]
  }
  
  encryption_info {
    encryption_in_transit {
      client_broker = var.TLS_SETTING
      in_cluster = true
    }
  }
  
}