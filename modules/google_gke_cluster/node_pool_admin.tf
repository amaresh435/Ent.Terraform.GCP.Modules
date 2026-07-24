resource "google_container_node_pool" "admin" {
  project    = var.project_id
  name       = "admin-pool"
  location   = var.region
  cluster    = google_container_cluster.this.name
  node_count = var.admin_node_count

  node_config {
    machine_type    = var.admin_node_machine_type
    service_account = google_service_account.nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    labels          = merge(var.labels, { pool = "admin" })
    tags            = ["gke-${var.cluster_name}"]
    taint {
      key    = "dedicated"
      value  = "admin"
      effect = "NO_SCHEDULE"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
