resource "google_service_account" "nodes" {
  project      = var.project_id
  account_id   = "${substr(var.cluster_name, 0, 20)}-nodes"
  display_name = "GKE node service account for ${var.cluster_name}"
}

resource "google_container_cluster" "this" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.region

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1
  min_master_version       = var.kubernetes_version

  release_channel {
    channel = var.release_channel
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {}

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  resource_labels = var.labels

  lifecycle {
    ignore_changes = [node_config]
  }
}
