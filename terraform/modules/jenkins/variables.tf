variable "environment" {
  description = "The environment name to be used as a unique identifier for all resources created by this module."
  type        = string
}

variable "key_pair_name" {
  description = "The name of the key pair to be used for the Jenkins instance."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to be used for the Jenkins instance."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to be used for the Jenkins instance."
  type        = string
}

variable "app_name" {
  description = "The name of the Jenkins instance."
  type        = string
}
