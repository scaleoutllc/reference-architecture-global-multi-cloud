
resource "google_container_node_pool" "app" {
  name              = "${local.envName}-app"
  cluster           = google_container_cluster.main.name
  node_count        = 1 // per zone
  max_pods_per_node = 50
  node_config {
    disk_size_gb    = 20
    preemptible     = true
    machine_type    = "e2-small"
    service_account = google_service_account.nodes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      "node.wescaleout.cloud/app" = "true"
    }
    taint {
      key    = "node.wescaleout.cloud/app"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }
}
