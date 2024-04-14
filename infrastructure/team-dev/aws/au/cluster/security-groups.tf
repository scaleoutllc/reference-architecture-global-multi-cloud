resource "aws_security_group" "lb-to-routing-nodes" {
  name        = "${local.envName}-lb-to-routing-nodes"
  description = "Allow inbound traffic to routing nodes."
  vpc_id      = local.network.vpc_id
  tags = {
    Name = "${local.envName}-lb-to-routing-nodes"
  }
}
