resource "aws_lb" "public_ingress" {
  name    = local.name
  subnets = local.network.public_subnets
  security_groups = [
    local.network.world_ingress_security_group_id
  ]
  tags = merge(local.tags, {
    Name = local.name
  })
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_lb_target_group" "public_ingress" {
  name     = "${local.name}-ingress"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = local.network.vpc_id
  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    port                = 30021
    path                = "/healthz/ready"
    interval            = 15
  }
}

resource "aws_autoscaling_attachment" "public_ingress" {
  lb_target_group_arn    = aws_lb_target_group.public_ingress.arn
  autoscaling_group_name = local.cluster.routing_autoscaling_group_id
}

resource "aws_lb_listener" "public_ingress_nonsecure" {
  load_balancer_arn = aws_lb.public_ingress.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "public_ingress" {
  load_balancer_arn = aws_lb.public_ingress.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = local.routing.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_ingress.arn
  }
}

// hide endpoints
resource "aws_lb_listener_rule" "public_ingress_prevent_public" {
  for_each = {
    metrics = {
      status_code  = 404
      message_body = "Not Found"
    },
    health = {
      status_code  = 404
      message_body = "Not Found"
    },
    liveness = {
      status_code  = 404
      message_body = "Not Found"
    }
    readiness = {
      status_code  = 404
      message_body = "Not Found"
    }
  }
  listener_arn = aws_lb_listener.public_ingress.arn
  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = each.value.message_body
      status_code  = each.value.status_code
    }
  }
  condition {
    path_pattern {
      values = [format("/%s", each.key)]
    }
  }
}


