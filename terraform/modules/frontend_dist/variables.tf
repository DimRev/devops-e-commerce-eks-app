variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket to use as origin"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to use as origin"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
}

variable "html_directory" {
  description = "Directory in the S3 bucket where HTML files are stored"
  type        = string
  default     = "html"
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100" # Use only North America and Europe
}

variable "default_root_object" {
  description = "Default root object for CloudFront"
  type        = string
  default     = "index.html"
}

variable "allowed_methods" {
  description = "HTTP methods that CloudFront processes and forwards to your origin"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "HTTP methods for which CloudFront caches responses"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "min_ttl" {
  description = "Minimum amount of time objects stay in CloudFront caches"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default amount of time objects stay in CloudFront caches"
  type        = number
  default     = 3600 # 1 hour
}

variable "max_ttl" {
  description = "Maximum amount of time objects stay in CloudFront caches"
  type        = number
  default     = 86400 # 24 hours
}
