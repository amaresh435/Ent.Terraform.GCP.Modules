resource "google_container_node_pool" "primary" {
  project    = var.project_id
  name       = "primary-pool"
  location   = var.region
  cluster    = google_container_cluster.this.name
  node_count = var.primary_node_count

  node_config {
    machine_type    = var.primary_node_machine_type
    service_account = google_service_account.nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    labels          = merge(var.labels, { pool = "primary" })
    tags            = ["gke-${var.cluster_name}"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
