output "public_ip" {
  description = "Jenkins public IP or Load Balancer hostname."
  value       = aws_instance.jenkins.public_ip
}

output "security_group_id" {
  description = "Jenkins security group ID."
  value       = aws_security_group.jenkins_sg.id
}
