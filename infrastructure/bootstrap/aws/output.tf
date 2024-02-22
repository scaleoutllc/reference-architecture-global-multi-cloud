output "terraform-cloud" {
  value = <<-EOF
Set the following as environment variables in Terraform Cloud:
TFC_AWS_PROVIDER_AUTH=true
TFC_AWS_RUN_ROLE_ARNL=${aws_iam_role.tfc.arn}
EOF
}
