output "routing_autoscaling_group_id" {
  value = module.routing-nodes.node_group_autoscaling_group_names[0]
}
