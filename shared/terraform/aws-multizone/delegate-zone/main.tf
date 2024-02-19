resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "main-delegate" {
  zone_id = var.parent_zone_id
  name    = aws_route53_zone.main.name
  records = aws_route53_zone.main.name_servers
  ttl     = 60
  type    = "NS"
}
