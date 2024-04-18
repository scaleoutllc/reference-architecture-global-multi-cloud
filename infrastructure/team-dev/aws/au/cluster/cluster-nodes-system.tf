module "system-nodes" {
  source        = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version       = "~> 20.8.5"
  name          = "${local.envName}-system"
  iam_role_name = "${local.envName}-system-node"
  labels = {
    "node.wescaleout.cloud/system" = "true"
  }
  cluster_name                      = module.eks.cluster_name
  cluster_service_cidr              = module.eks.cluster_service_cidr
  subnet_ids                        = local.network.private_subnets
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids = [
    module.eks.node_security_group_id
  ]
  instance_types           = ["t3.medium", "t3.small"]
  capacity_type            = "SPOT"
  min_size                 = 2
  max_size                 = 6
  desired_size             = 3
  use_name_prefix          = false
  iam_role_use_name_prefix = false
}
