output "id" {
  value = oci_containerengine_cluster.main.id
}

output "endpoint" {
  value = oci_containerengine_cluster.main.endpoints[0].public_endpoint
}

output "kubectl-bootstrap" {
  value = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.main.id} --profile scaleout"
}

output "routing-node-pool-id" {
  value = oci_containerengine_node_pool.routing.id
}

output "lb-to-cluster" {
  value = oci_core_network_security_group.lb-to-cluster.id
}
