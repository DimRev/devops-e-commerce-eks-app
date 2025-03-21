# GLOBAL
variable "environment" {
  description = "The environment name to be used as a unique identifier for all resources created by this module."
  type        = string
  default     = "dev"
}

# VPC

variable "vpc_region" {
  description = "The region where the VPC is created."
  type        = string
  default     = "us-east-1"
}

# EKS

variable "eks_nodes_desired_capacity" {
  description = "The desired capacity of the EKS nodes."
  type        = number
  default     = 3
}

variable "eks_nodes_max_size" {
  description = "The maximum capacity of the EKS nodes."
  type        = number
  default     = 6
}

variable "eks_nodes_min_size" {
  description = "The minimum capacity of the EKS nodes."
  type        = number
  default     = 2
}

variable "app_name" {
  description = "The name of the Jenkins instance."
  type        = string
  default     = "e-commerce"
}
