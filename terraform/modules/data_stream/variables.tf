variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket where Firehose should write its data."
  type        = string
}

variable "retention_period" {
  description = "Kinesis stream retention period (in hours)."
  type        = number
  default     = 24
}

variable "buffering_size" {
  description = "Buffering size (in MB) for Firehose."
  type        = number
  default     = 5
}

variable "buffering_interval" {
  description = "Buffering interval (in seconds) for Firehose."
  type        = number
  default     = 60
}

variable "iam_name_prefix" {
  description = "Prefix used for naming IAM policies and roles."
  type        = string
  default     = "kinesis-firehose-"
}

variable "bucker_path_prefix" {
  description = "The path prefix for the S3 bucket where Firehose should write its data."
  type        = string
}


variable "name_prefix" {
  description = "A prefix used for naming resources (such as CloudWatch log groups)."
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "app_name" {
  description = "Name of the Kinesis Stream"
  type        = string
}

variable "eks_cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL of the EKS cluster."
  type        = string
}
