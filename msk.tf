resource "aws_msk_cluster" "demo-msk" {
  cluster_name           = "demo-msk-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3
  broker_node_group_info {
    instance_type   = "kafka.t3.small" # Choose an appropriate instance type
    ebs_volume_size = 10
    client_subnets  = distinct(data.aws_subnets.client_subnets.ids) # Specify your VPC subnets
    security_groups = [aws_security_group.msk.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster    = false
    }
  }
  configuration_info {
    arn      = aws_msk_configuration.demo-msk-configuration.arn
    revision = aws_msk_configuration.demo-msk-configuration.latest_revision
  }

  tags = {
    Name = "Demo MSK Cluster"
  }
  depends_on = [aws_msk_configuration.demo-msk-configuration, aws_security_group.msk]
}

resource "aws_msk_configuration" "demo-msk-configuration" {
  name           = "demo-msk-configuration"
  description    = "Demo MSK Configuration"
  kafka_versions = ["2.8.1"]

  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
log.retention.hours = 48
PROPERTIES

}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.demo-msk.zookeeper_connect_string
}


resource "aws_security_group" "msk" {

  lifecycle {
    create_before_destroy = true
  }

  description = "Sg with all ports open to egress."
  name        = "${local.resource_name_prefix}-msk-demo-msk-cluster"
  vpc_id      = local.vpc_id
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }
  tags = {
    Name        = "${local.resource_name_prefix}-msk-demo-msk-cluster"
    Description = "Sg with all ports open to egress."
  }
}

locals {
  msk_sg_rules = [
    {
      cidr_blocks              = ["0.0.0.0/0"]
      from_port                = 0
      protocol                 = -1
      self                     = null
      source_security_group_id = null
      to_port                  = 0
      type                     = "ingress"
      prefix_list_ids          = null
      ipv6_cidr_blocks         = null
    }
  ]
}
resource "aws_security_group_rule" "msk" {

  lifecycle {
    create_before_destroy = true
  }

  count                    = length(local.msk_sg_rules)
  description              = try(local.msk_sg_rules[count.index].description, null)
  cidr_blocks              = try(local.msk_sg_rules[count.index].cidr_blocks, null)
  from_port                = try(local.msk_sg_rules[count.index].from_port, null)
  protocol                 = try(local.msk_sg_rules[count.index].protocol, null)
  self                     = try(local.msk_sg_rules[count.index].self ? local.msk_sg_rules[count.index].self : null, null)
  security_group_id        = aws_security_group.msk.id
  source_security_group_id = try(local.msk_sg_rules[count.index].source_security_group_id == "" ? null : local.msk_sg_rules[count.index].source_security_group_id, null)
  to_port                  = try(local.msk_sg_rules[count.index].to_port, null)
  type                     = try(local.msk_sg_rules[count.index].type, null)
  prefix_list_ids          = try(local.msk_sg_rules[count.index].prefix_list_ids, null)
  ipv6_cidr_blocks         = try(local.msk_sg_rules[count.index].ipv6_cidr_blocks, null)

}
