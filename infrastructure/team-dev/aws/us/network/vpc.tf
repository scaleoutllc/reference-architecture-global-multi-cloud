module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7"

  name = local.name
  cidr = "10.10.0.0/20"

  azs = ["${data.aws_region.this_env.name}a", "${data.aws_region.this_env.name}b", "${data.aws_region.this_env.name}c"]

  # for slice up info see: https://www.davidc.net/sites/default/subnets/subnets.html?network=10.10.0.0&mask=20&division=25.3d9cc40
  private_subnets  = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
  database_subnets = ["10.10.12.0/25", "10.10.12.128/25", "10.10.13.0/25"]
  # reserved for something in future: 10.10.13.128/25 10.10.14.0/25 10.10.14.128/25
  public_subnets = ["10.10.15.0/26", "10.10.15.64/26", "10.10.15.128/26"] #10.10.15.192/26 left over

  create_database_subnet_group = false

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "acl-${local.name}-default" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "rtb-${local.name}-default" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "sg-${local.name}-default" }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  enable_vpn_gateway = false

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  tags = local.tags
}
