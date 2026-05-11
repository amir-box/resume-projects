resource "aws_route53_zone" "this" {
  name = var.domain_name
}

resource "aws_globalaccelerator_accelerator" "this" {
  name            = "calebhotelsuite-ga"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "http" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "singapore" {
  listener_arn = aws_globalaccelerator_listener.http.id

  endpoint_group_region = "ap-southeast-1"

  endpoint_configuration {
    endpoint_id = var.alb_singapore_arn
    weight      = 100
  }
}

resource "aws_globalaccelerator_endpoint_group" "tokyo" {
  listener_arn = aws_globalaccelerator_listener.http.id

  endpoint_group_region = "ap-northeast-1"

  endpoint_configuration {
    endpoint_id = var.alb_tokyo_arn
    weight      = 100
  }
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_globalaccelerator_accelerator.this.dns_name
    zone_id                = aws_globalaccelerator_accelerator.this.hosted_zone_id
    evaluate_target_health = false
  }
}



resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

