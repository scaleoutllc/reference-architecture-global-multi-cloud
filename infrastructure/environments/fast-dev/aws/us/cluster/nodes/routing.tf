module "routing-nodes" {
  source        = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version       = "~> 20.8.5"
  name          = "${local.name}-routing"
  iam_role_name = "${local.name}-routing-node"
  labels = {
    "node.wescaleout.cloud/routing" = "true"
  }
  taints = [
    {
      key    = "node.wescaleout.cloud/routing"
      value  = "true"
      effect = "NO_SCHEDULE"

    }
  ]
  cluster_name                      = local.cluster.name
  cluster_service_cidr              = local.cluster.service_cidr
  subnet_ids                        = local.network.private_subnets
  cluster_primary_security_group_id = local.cluster.primary_security_group_id
  vpc_security_group_ids = [
    local.cluster.node_security_group_id,
    local.network.internal_ingress_security_group_id
  ]
  min_size     = 2
  max_size     = 6
  desired_size = 3
  instance_types = [
    "t2.medium",
    "t3.medium",
    "m3.medium"
  ]
  capacity_type            = "SPOT"
  use_name_prefix          = false
  iam_role_use_name_prefix = false
}
