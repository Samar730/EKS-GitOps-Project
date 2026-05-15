output "rds_endpoint" {
  description = "RDS PostgreSQL Endpoint"
  value       = module.rds.rds_endpoint
  sensitive   = true
}