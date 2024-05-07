# This security group is created for use with VPC endpoints, because our nodes are going to be the primary users
# of the VPC endpoints we need to explicitly add rules for them to be able to communicate. This isn't posisble to
# do during VPC creation because we have no yet made the EKS cluster.
# Instead, we fetch the security group that is created for the endpoints and add one-off rules per what EKS requires.
data "aws_security_group" "vpc_endpoints" {
  name = "${local.name}-vpc-interface-ingress"
}

resource "aws_security_group_rule" "private_subnets" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = local.network.private_subnets_cidr_blocks
  security_group_id = data.aws_security_group.vpc_endpoints.id
}

resource "aws_security_group_rule" "eks_cluster_sg" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = data.aws_security_group.vpc_endpoints.id
}

resource "aws_security_group_rule" "eks_nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks.node_security_group_id
  security_group_id        = data.aws_security_group.vpc_endpoints.id
}
