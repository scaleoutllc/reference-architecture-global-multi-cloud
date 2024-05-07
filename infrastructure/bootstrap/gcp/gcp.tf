# module "gcp-us" {
#   source       = "../../../shared/terraform/workspace"
#   organization = "scaleout"
#   name         = "${local.name}-gcp-us"
#   root_path    = "infrastructure/${local.name}/gcp/us"
#   workspaces = [
#     { path = "network" },
#     { path = "cluster/gke" },
#     { path = "cluster/nodes" },
#     { path = "cluster/namespaces/istio-system" },
#     { path = "cluster/namespaces/main" },
#     { path = "routing" },
#   ]
# }

# module "gcp-au" {
#   source       = "../../../shared/terraform/workspace"
#   organization = "scaleout"
#   name         = "${local.name}-gcp-au"
#   root_path    = "infrastructure/${local.name}/gcp/au"
#   workspaces = [
#     { path = "network" },
#     { path = "cluster/gke" },
#     { path = "cluster/nodes" },
#     { path = "cluster/namespaces/istio-system" },
#     { path = "cluster/namespaces/main" },
#     { path = "routing" },
#   ]
# }
