output "rds_endpoint" {
  description = "RDS PostgreSQL Endpoint"
  value       = aws_db_instance.postgresql.endpoint
  sensitive = true
}

output "rds_db_name" {
  description = "RDS Database Name"
  value       = aws_db_instance.postgresql.db_name
}