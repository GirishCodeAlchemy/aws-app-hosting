
# This needs to be filtered to just the private subnets
data "aws_subnets" "client_subnets" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  filter {
    name = "tag:Name"
    values = [
      "Internal-A-Subnet",
      "Internal-B-Subnet",
      "Internal-C-Subnet"
    ]
  }
}
