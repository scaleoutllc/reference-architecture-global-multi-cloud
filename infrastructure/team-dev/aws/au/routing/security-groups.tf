resource "aws_security_group_rule" "eks_cluster_lb_ingress" {
  type                     = "ingress"
  from_port                = 31080
  to_port                  = 31080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_ingress.id
  security_group_id        = local.cluster.ingress_security_group_id
}

resource "aws_security_group_rule" "eks_cluster_lb_health_ingress" {
  type                     = "ingress"
  from_port                = 30877
  to_port                  = 30877
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_ingress.id
  security_group_id        = local.cluster.ingress_security_group_id
}
