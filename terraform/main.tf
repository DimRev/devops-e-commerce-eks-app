provider "aws" {
  region  = "us-east-1"
  profile = "e-commerce"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.environment}-${var.app_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
  tags = {
    Name      = "${var.environment}-${var.app_name}-key"
    Terraform = "true"
    Env       = var.environment
  }
}

resource "aws_s3_bucket" "app_bucket" {
  bucket        = "${var.environment}-${var.app_name}-app-bucket"
  force_destroy = var.environment == "dev" ? true : false
  tags = {
    Name      = "${var.environment}-${var.app_name}-app-bucket"
    Terraform = "true"
    Env       = var.environment
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  name    = "${var.environment}-${var.app_name}-vpc"
  cidr    = "10.0.0.0/16"

  azs             = ["${var.vpc_region}a", "${var.vpc_region}b", "${var.vpc_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name      = "${var.environment}-${var.app_name}-vpc"
    Terraform = "true"
    Env       = var.environment
  }
}

resource "aws_security_group" "jenkins_eks_ingress" {
  name        = "${var.environment}-${var.app_name}-jenkins-eks-sg"
  description = "Allow EKS to communicate with Jenkins"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [module.jenkins.security_group_id]
  }
  tags = {
    Name      = "${var.environment}-${var.app_name}-jenkins-eks-sg"
    Terraform = "true"
    Env       = var.environment
  }
}

resource "aws_security_group" "load_balancer_sg" {
  name        = "${var.environment}-${var.app_name}-lb-sg"
  description = "Security group for the load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere to port 80
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere to port 443
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name      = "${var.environment}-${var.app_name}-lb-sg"
    Terraform = "true"
    Env       = var.environment
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "${var.environment}-${var.app_name}-eks"
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_additional_security_group_ids = [
    aws_security_group.jenkins_eks_ingress.id,
    aws_security_group.load_balancer_sg.id
  ]

  eks_managed_node_groups = {
    eks_nodes = {
      desired_size = var.eks_nodes_desired_capacity
      max_size     = var.eks_nodes_max_size
      min_size     = var.eks_nodes_min_size

      instance_types = ["t3.medium"]

      labels = {
        Environment = var.environment
        Name        = "${var.environment}-${var.app_name}-eks-node"
      }
    }
  }

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  tags = {
    Name      = "${var.environment}-${var.app_name}-eks"
    Terraform = "true"
    Env       = var.environment
  }
}

module "log_data_stream" {
  source = "./modules/data_stream"

  s3_bucket_arn      = aws_s3_bucket.app_bucket.arn
  bucker_path_prefix = "logs"

  name_prefix = "logs"

  app_name    = var.app_name
  environment = var.environment

  eks_cluster_iam_role_name = module.eks.cluster_iam_role_name
}

module "jenkins" {
  source = "./modules/jenkins"

  key_pair_name = aws_key_pair.key_pair.key_name
  subnet_id     = module.vpc.public_subnets[0]
  vpc_id        = module.vpc.vpc_id

  app_name = var.app_name

  environment = var.environment
}

# Add the frontend_dist module
module "frontend_dist" {
  source = "./modules/frontend_dist"

  app_name              = var.app_name
  environment           = var.environment
  s3_bucket_id          = aws_s3_bucket.app_bucket.id
  s3_bucket_arn         = aws_s3_bucket.app_bucket.arn
  s3_bucket_domain_name = aws_s3_bucket.app_bucket.bucket_regional_domain_name
  html_directory        = "html" # Directory in the bucket where React app files will be stored
}
