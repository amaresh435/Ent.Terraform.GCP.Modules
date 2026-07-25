# Enterprise Terraform GCP Modules

## GKE cluster module

`modules/google_gke_cluster` creates a regional, VPC-native private-node GKE
cluster with a primary and an admin node pool. It creates a dedicated node
service account and grants the required `roles/container.defaultNodeServiceAccount`
role. Workloads must use Workload Identity for access to Google Cloud resources.

Before applying, the Terraform execution identity needs the following permissions
in the target project (and in the Shared VPC host project when applicable):

- `roles/container.admin`
- `roles/compute.networkAdmin`
- `roles/iam.serviceAccountAdmin`
- `roles/iam.serviceAccountUser` on the created node service account
- `resourcemanager.projects.setIamPolicy` when this module manages node,
  administrator, developer, or Artifact Registry IAM bindings
- `serviceusage.services.enable` when `enable_required_apis = true`

Use a narrow custom role instead of broad predefined roles where your
organization requires it. The module cannot safely bootstrap these permissions
for its own execution identity.

Example:

```hcl
module "gke" {
  source = "./modules/google_gke_cluster"

  project_id          = "example-project"
  region              = "asia-south1"
  cluster_name        = "platform"
  network             = "platform-vpc"
  subnetwork          = "platform-gke"
  pod_subnet_name     = "gke-pods"
  svc_subnet_name     = "gke-services"
  cluster_master_cidr = "172.16.0.0/28"

  master_authorized_networks = [{
    cidr_block   = "203.0.113.0/24"
    display_name = "corporate-egress"
  }]

  cluster_admin_members     = ["group:platform-admins@example.com"]
  cluster_developer_members = ["group:platform-developers@example.com"]
}
```

`cluster_admin_members` receive `roles/container.admin`; developer members
receive `roles/container.developer`, which permits access to Kubernetes API
objects. Keep these lists empty when project IAM is managed in a separate IAM
module.

With the default public control-plane endpoint, define
`master_authorized_networks`. Set `enable_private_endpoint = true` only when
operators and CI run from the VPC (or a connected network). The firewall rule is
disabled unless `firewall_source_ranges` is set; it targets the node tag managed
by this module.
