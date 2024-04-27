output "kubectl-bootstrap" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${data.aws_region.this_env.name} --profile ${local.region}"
}

output "name" {
  value = module.eks.cluster_name
}

output "primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "service_cidr" {
  value = module.eks.cluster_service_cidr
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}
