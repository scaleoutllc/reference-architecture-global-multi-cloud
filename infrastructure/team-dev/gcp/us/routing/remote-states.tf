data "terraform_remote_state" "routing" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "scaleout-platform-team-dev-routing"
    }
  }
}

data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "gcp-team-dev-us-network"
    }
  }
}

locals {
  routing = data.terraform_remote_state.routing.outputs.gcp-us
  network = data.terraform_remote_state.network.outputs
}
