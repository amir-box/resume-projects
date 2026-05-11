output "alb_dns" {
  value = module.alb.lb_dns_name
}

output "waf_arn" {
  value = aws_wafv2_web_acl.this.arn
}