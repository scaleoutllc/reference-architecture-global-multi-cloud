output "kubectl-bootstrap" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${data.aws_region.this_env.name} --profile ${local.region}"
}

output "routing_autoscaling_group_id" {
  value = module.routing-nodes.node_group_autoscaling_group_names[0]
}

output "ingress_security_group_id" {
  value = aws_security_group.lb-to-routing-nodes.id
}
