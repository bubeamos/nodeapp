# outputs.tf

output "node_application_url" {
  value = aws_route53_record.nodeapp_record.name
  description = "The Application Can Be Accessed using this URL"
}

