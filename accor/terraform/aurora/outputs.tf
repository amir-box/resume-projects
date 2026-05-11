output "primary_writer_endpoint" {
  value = module.aurora_primary.cluster_endpoint
}

output "primary_reader_endpoint" {
  value = module.aurora_primary.cluster_reader_endpoint
}

output "secondary_reader_endpoint" {
  value = module.aurora_secondary.cluster_reader_endpoint
}