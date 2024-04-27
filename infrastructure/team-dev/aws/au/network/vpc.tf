module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7"
  name    = local.name
  azs = [
    "${data.aws_region.this_env.name}a",
    "${data.aws_region.this_env.name}b",
    "${data.aws_region.this_env.name}c"
  ]
  cidr            = local.network.cidr
  private_subnets = local.network.private_subnets
  public_subnets  = local.network.public_subnets
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  create_database_subnet_group         = false
  manage_default_network_acl           = true
  default_network_acl_tags             = { Name = "${local.name}-default" }
  manage_default_route_table           = true
  default_route_table_tags             = { Name = "${local.name}-default" }
  manage_default_security_group        = true
  default_security_group_tags          = { Name = "${local.name}-default" }
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_nat_gateway                   = true
  single_nat_gateway                   = false
  one_nat_gateway_per_az               = true
  enable_vpn_gateway                   = false
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  tags                                 = local.tags
}
