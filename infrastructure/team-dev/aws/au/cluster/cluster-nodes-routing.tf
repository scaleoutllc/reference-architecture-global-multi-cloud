module "routing-nodes" {
  source        = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version       = "~> 20.8.5"
  name          = "${local.envName}-routing"
  iam_role_name = "${local.envName}-routing-node"
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
  cluster_name                      = module.eks.cluster_name
  cluster_service_cidr              = module.eks.cluster_service_cidr
  subnet_ids                        = local.network.vpc.private_subnets
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids = [
    module.eks.node_security_group_id,
    aws_security_group.lb-to-routing-nodes.id
  ]
  min_size                 = 2
  max_size                 = 6
  desired_size             = 3
  instance_types           = ["t3.medium", "t3.small"]
  capacity_type            = "SPOT"
  use_name_prefix          = false
  iam_role_use_name_prefix = false
}
