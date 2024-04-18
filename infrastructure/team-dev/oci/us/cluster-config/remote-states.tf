data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "oci-team-dev-us-cluster"
    }
  }
}

locals {
  cluster = data.terraform_remote_state.cluster.outputs
}
