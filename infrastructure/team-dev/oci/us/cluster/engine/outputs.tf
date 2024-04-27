output "id" {
  value = oci_containerengine_cluster.main.id
}

output "endpoint" {
  value = oci_containerengine_cluster.main.endpoints[0].public_endpoint
}

output "kubectl-bootstrap" {
  value = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.main.id} --profile scaleout"
}

output "ca-cert" {
  value     = base64decode(local.kubeconfig.certificate-authority-data)
  sensitive = true
}
