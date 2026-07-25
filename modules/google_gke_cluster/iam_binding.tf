resource "google_project_iam_member" "nodes_default_role" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.nodes.email}"
}

resource "google_project_iam_member" "nodes_artifact_registry_reader" {
  count = var.grant_node_artifact_registry_reader ? 1 : 0

  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.nodes.email}"
}

# These bindings grant GKE IAM access. They do not grant access to application
# Google Cloud resources; use Workload Identity for that purpose.
resource "google_project_iam_member" "cluster_admin" {
  for_each = toset(var.cluster_admin_members)

  project = var.project_id
  role    = "roles/container.admin"
  member  = each.value
}

resource "google_project_iam_member" "cluster_developer" {
  for_each = toset(var.cluster_developer_members)

  project = var.project_id
  role    = "roles/container.developer"
  member  = each.value
}
