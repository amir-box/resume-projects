

output "name_servers" {
  value = aws_route53_zone.this.name_servers
}

output "ga_ip_addresses" {
  value = aws_globalaccelerator_accelerator.this.ip_sets
}

output "domain" {
  value = var.domain_name
}
