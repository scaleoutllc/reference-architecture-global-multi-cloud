resource "aws_security_group" "internal-ingress" {
  name        = "${local.name}-internal-ingress"
  description = "Make private resources (e.g. nodes) accept requests from public resources (e.g. load balancers)."
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "${local.name}-internal-ingress"
  }
}

resource "aws_security_group_rule" "internal-ingress-http" {
  security_group_id        = aws_security_group.internal-ingress.id
  description              = "Private/dedicated routing nodes should use this port to accept HTTP traffic. Public load balancers should redirect all HTTP traffic to HTTPS and target this port after terminating TLS."
  type                     = "ingress"
  from_port                = 30080
  to_port                  = 30080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.world-ingress.id
}

resource "aws_security_group_rule" "internal-ingress-health-check" {
  security_group_id        = aws_security_group.internal-ingress.id
  description              = "Public load balancers should use this port to health check whatever internal gateway is used to route traffic into the cluster (if other than 30080)."
  type                     = "ingress"
  from_port                = 30021
  to_port                  = 30021
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.world-ingress.id
}

resource "aws_security_group" "world-ingress" {
  name        = "${local.name}-world-ingress"
  description = "Let public load balancers accept HTTP/HTTPS traffic and send responses."
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.tags, {
    Name = "${local.name}-world-ingress"
  })
  lifecycle {
    ignore_changes = [tags]
  }
}
