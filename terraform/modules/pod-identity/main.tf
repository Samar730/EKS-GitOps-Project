# Fetch the Route53 hosted zone for cloudbysamar.com
data "aws_route53_zone" "main" {
    name = var.domain_name
    private_zone = false # determines that it is resolvable from the internet
}

# Create the IAM role for ExternalDNS
resource "aws_iam_role" "pod_identity_external_dns" {
  name = "${var.project_name}-externaldns-role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession"]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy -> Necessary actions needed by ExternalDNS to perform Route53 permissions
resource "aws_iam_policy" "external_dns_policy" {
    name = "${var.project_name}-externaldns-policy"
    
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          # ListHostedZones must target * as it is a global action not specific to a zone
          Effect   = "Allow"
          Action   = ["route53:ListHostedZones"]
          Resource = "*"
        },
        {
          # Record set actions are scoped to the specific hosted zone only
          Effect   = "Allow"
          Action   = [
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets"
          ]
          Resource = "arn:aws:route53:::hostedzone/${data.aws_route53_zone.main.zone_id}"
        }
      ]
    })
}

# Attach the policy to the IAM role 
resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
    policy_arn = aws_iam_policy.external_dns_policy.arn
    role = aws_iam_role.pod_identity_external_dns.name
}

#  links the IAM role to the ExternalDNS service account inside the cluster
resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = var.eks_cluster_name
  namespace       = "external-dns"
  service_account = "external-dns"
  role_arn        = aws_iam_role.pod_identity_external_dns.arn
}

# IAM Role for ESO -> handles RDS Credentials with external service
resource "aws_iam_role" "eso" {
   name = "${var.project_name}-eso-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession"]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy -> Necessary actions needed by ESO to handle external secrets
resource "aws_iam_policy" "eso_policy" {
  name = "${var.project_name}-eso-policy"

  policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
          ]
          Resource = "arn:aws:secretsmanager:eu-west-2:821868546219:secret:memos-dsn*"
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "eso_policy_attachment" {
  policy_arn = aws_iam_policy.eso_policy.arn
  role = aws_iam_role.eso.name
}

resource "aws_eks_pod_identity_association" "eso_pod_identity" {
  cluster_name    = var.eks_cluster_name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.eso.arn
}