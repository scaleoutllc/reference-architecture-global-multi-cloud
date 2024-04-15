data "terraform_remote_state" "routing" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "scaleout-platform-routing"
    }
  }
}

locals {
  routing = data.terraform_remote_state.routing.outputs
}
