data "terraform_remote_state" "team-dev-routing" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "team-dev-routing"
    }
  }
}

locals {
  routing = data.terraform_remote_state.team-dev-routing.outputs
}
