locals {
  bucket_name = "${local.name}-website"
}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
}

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "${aws_s3_bucket.main.id} access identity"
}

data "aws_iam_policy_document" "main" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.main.bucket
  key          = "index.html"
  content      = local.name
  content_type = "text/html"
}

resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = local.routing.sans
  origin {
    origin_id   = aws_s3_bucket.main.id
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }
  viewer_certificate {
    acm_certificate_arn      = local.routing.certificate_arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }
  default_cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods  = ["HEAD", "GET"]
    compress        = true
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
    target_origin_id       = aws_s3_bucket.main.id
    viewer_protocol_policy = "redirect-to-https"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

locals {
  zones = local.routing.zones["${local.provider}-${local.region}"]
}

resource "aws_route53_record" "apex" {
  for_each = { for zone in local.zones : zone.name => zone.id }
  zone_id  = each.value
  name     = each.key
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard" {
  for_each = { for zone in local.zones : zone.name => zone.id }
  zone_id  = each.value
  name     = "*"
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}
