resource "aws_msk_cluster" "demo-msk" {
  cluster_name           = "demo-msk-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2
  broker_node_group_info {
    instance_type   = "kafka.t3.small" # Choose an appropriate instance type
    ebs_volume_size = 50
    client_subnets  = distinct(data.aws_subnets.client_subnets.ids) # Specify your VPC subnets
    security_groups = data.aws_security_groups.default-sg.ids
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
  depends_on = [aws_msk_configuration.demo-msk-configuration]
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
