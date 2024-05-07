
resource "google_container_node_pool" "system" {
  name              = "${local.name}-system"
  cluster           = local.cluster.name
  node_count        = 1 // per zone
  max_pods_per_node = 50
  node_config {
    disk_size_gb    = 20
    preemptible     = true
    machine_type    = "e2-medium"
    service_account = local.cluster.node-sa-email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
