output "kubectl-bootstrap" {
  value = <<EOF
gcloud container clusters get-credentials ${local.envName} --region us-east1 --project scaleout-team-dev-us
EOF
}
