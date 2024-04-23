output "kubectl-bootstrap" {
  value = <<EOF
gcloud container clusters get-credentials ${local.envName} --region australia-southeast1 --project scaleout-team-dev-au
EOF
}
