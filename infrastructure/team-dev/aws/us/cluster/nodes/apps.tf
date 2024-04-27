module "app-nodes" {
  source        = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version       = "~> 20.8.5"
  name          = "${local.name}-app"
  iam_role_name = "${local.name}-app-node"
  labels = {
    "node.kubernetes.io/app" = "true"
  }
  taints = [
    {
      key    = "node.kubernetes.io/app"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  ]
  cluster_name                      = local.name
  cluster_service_cidr              = local.cluster.service_cidr
  subnet_ids                        = local.network.private_subnets
  cluster_primary_security_group_id = local.cluster.primary_security_group_id
  vpc_security_group_ids = [
    local.cluster.node_security_group_id
  ]
  instance_types = [
    "t2.small",
    "t3.small",
    "t2.medium",
    "t3.medium",
    "m3.medium"
  ]
  capacity_type            = "SPOT"
  min_size                 = 2
  max_size                 = 6
  desired_size             = 3
  use_name_prefix          = false
  iam_role_use_name_prefix = false
}
