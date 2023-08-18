output "web_acl_id" {
  description = "ARN do WAF WebACL."
  value       = aws_wafv2_web_acl.main.arn
}

