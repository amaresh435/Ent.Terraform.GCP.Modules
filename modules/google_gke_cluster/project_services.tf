# Enabling APIs is opt-in because it changes project-wide state and requires
# serviceusage.services.enable on the Terraform execution identity.
resource "google_project_service" "required" {
  for_each = var.enable_required_apis ? toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]) : toset([])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
