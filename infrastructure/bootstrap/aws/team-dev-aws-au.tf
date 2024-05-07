
resource "aws_iam_role" "tfc-team-dev-aws-au" {
  name               = "tfc-team-dev-aws-au"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "${aws_iam_openid_connect_provider.tfc.arn}"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "${local.tfc.hostname}:aud": "${local.tfc.audience}"
       },
       "StringLike": {
         "${local.tfc.hostname}:sub": "organization:scaleout:project:${tfe_project.team-dev-aws-au.name}:workspace:*:run_phase:*"
       }
     }
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tfc-team-dev-aws-au" {
  role       = aws_iam_role.tfc-team-dev-aws-au.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "tfe_project" "team-dev-aws-au" {
  organization = "scaleout"
  name         = "team-dev-aws-au"
}

resource "tfe_variable_set" "team-dev-aws-au" {
  name         = "team-dev-aws-au"
  organization = "scaleout"
}

resource "tfe_variable" "team-dev-aws-au" {
  for_each = {
    TFC_AWS_PROVIDER_AUTH = true
    TFC_AWS_RUN_ROLE_ARN  = aws_iam_role.tfc-team-dev-aws-au.arn
  }
  variable_set_id = tfe_variable_set.team-dev-aws-au.id
  key             = each.key
  value           = each.value
  category        = "env"
}

resource "tfe_project_variable_set" "team-dev-aws-au" {
  project_id      = tfe_project.team-dev-aws-au.id
  variable_set_id = tfe_variable_set.team-dev-aws-au.id
}

resource "tfe_workspace" "team-dev-aws-au" {
  for_each = toset([
    "network",
    "cluster/eks",
    "cluster/nodes",
    "cluster/namespaces/istio-system",
    "cluster/namespaces/main",
    "routing",
  ])
  name                = "${tfe_project.team-dev-aws-au.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.team-dev-aws-au.id
  working_directory   = "infrastructure/team-dev/aws/us/${each.value}"
  global_remote_state = true
  vcs_repo {
    identifier     = "scaleoutllc/reference-architecture"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
    branch         = "main"
  }
  lifecycle {
    prevent_destroy = false
  }
}
