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
      name = "aws-team-dev-us-network"
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "aws-team-dev-us-cluster"
    }
  }
}

locals {
  routing = data.terraform_remote_state.routing.outputs.aws-us
  network = data.terraform_remote_state.network.outputs
  cluster = data.terraform_remote_state.cluster.outputs
}
