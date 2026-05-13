output "external_dns_role_arn" {
  description = "IAM Role ARN for ExternalDNS Pod Identity"
  value       = aws_iam_role.pod_identity_external_dns.arn
}