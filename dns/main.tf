terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.62.0"
    }
  }
}

provider "aws" {
  # Route53 is a global resource, but the region will eventually be needed by other services.
  region = "us-east-1"
}

variable "domain_name" {
  description = "The name of the domain name to add to Route53."
  type        = string
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Add Google Workspace MX records
resource "aws_route53_record" "mx_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = "300"
  records = [
    "1 SMTP.GOOGLE.COM."
  ]
}
output "nameservers" {
  value       = aws_route53_zone.primary.name_servers
  description = "Custom nameservers provided by Route53."
}