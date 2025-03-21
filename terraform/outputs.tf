#############################
# EKS Outputs
#############################
output "eks_cluster_endpoint" {
  description = "EKS Cluster API endpoint."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS Cluster name."
  value       = module.eks.cluster_name
}

output "eks_cluster_oidc_issuer_url" {
  description = "EKS Cluster OIDC Issuer URL."
  value       = module.eks.cluster_oidc_issuer_url
}

#############################
# VPC Output
#############################
output "vpc_id" {
  description = "VPC ID used for the environment."
  value       = module.vpc.vpc_id
}

#############################
# App Bucket Output
#############################
output "app_bucket_name" {
  description = "S3 Bucket name for the application."
  value       = aws_s3_bucket.app_bucket.bucket
}

#############################
# Data Streams Outputs
#############################
output "kinesis_stream_arn" {
  description = "Kinesis Stream ARN from the data_stream module."
  value       = module.log_data_stream.kinesis_stream_arn
}

output "firehose_delivery_stream_arn" {
  description = "Firehose Delivery Stream ARN from the data_stream module."
  value       = module.log_data_stream.firehose_delivery_stream_arn
}

#############################
# Jenkins Output
#############################
output "jenkins_ip" {
  description = "Jenkins public IP or Load Balancer hostname."
  value       = module.jenkins.public_ip
}
