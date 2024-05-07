module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.8.5"
  cluster_name                             = local.name
  cluster_version                          = "1.29"
  vpc_id                                   = local.network.vpc_id
  subnet_ids                               = local.network.private_subnets
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
}
