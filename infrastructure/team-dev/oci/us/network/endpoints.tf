# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${data.aws_region.this_env.name}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids = concat(
#     module.vpc.public_route_table_ids,
#     module.vpc.private_route_table_ids,
#     module.vpc.database_route_table_ids
#   )
# }

# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${data.aws_region.this_env.name}.ecr.api"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = [
#     aws_security_group.vpc_interface_ingress.id,
#   ]
#   subnet_ids          = module.vpc.private_subnets
#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${data.aws_region.this_env.name}.ecr.dkr"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = [
#     aws_security_group.vpc_interface_ingress.id,
#   ]
#   subnet_ids          = module.vpc.private_subnets
#   private_dns_enabled = true
# }

# resource "aws_security_group" "vpc_interface_ingress" {
#   vpc_id = module.vpc.vpc_id
#   name   = "${module.vpc.name}-vpc-interface-ingress"

#   tags = merge(local.tags, {
#     Name = "${module.vpc.name}-vpc-interface-ingress"
#   })
#   lifecycle {
#     ignore_changes = [tags]
#   }
# }
