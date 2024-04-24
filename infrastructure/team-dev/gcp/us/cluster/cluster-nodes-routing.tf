
resource "google_container_node_pool" "routing" {
  name              = "${local.envName}-routing"
  cluster           = google_container_cluster.main.name
  node_count        = 1 // per zone
  max_pods_per_node = 50
  node_config {
    disk_size_gb    = 20
    preemptible     = true
    machine_type    = "e2-medium"
    service_account = google_service_account.nodes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      "node.wescaleout.cloud/routing" = "true"
    }
    taint {
      key    = "node.wescaleout.cloud/routing"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }
}

