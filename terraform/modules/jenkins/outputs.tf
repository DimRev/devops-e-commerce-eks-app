output "public_ip" {
  description = "Jenkins public IP or Load Balancer hostname."
  value       = aws_instance.jenkins.public_ip
}
