output "app_url" {
  value = aws_lb.this.dns_name
}
