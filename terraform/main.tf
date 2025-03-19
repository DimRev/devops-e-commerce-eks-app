module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  name    = concat(var.environment, "-vpc")
  cidr    = "10.0.0.0/16"

  azs             = ["${var.vpc_region}a", "${var.vpc_region}b", "${var.vpc_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name      = concat(var.environment, "-vpc")
    Terraform = "true"
    Env       = var.environment
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = concat(var.environment, "-eks")
  cluster_version = "1.27"

  vpc_id     = module.vpc.default_vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = var.eks_nodes_desired_capacity
      max_size         = var.eks_nodes_max_size
      min_size         = var.eks_nodes_min_size

      instance_types = ["t3.medium"]

      labels = {
        Environment = var.environment
      }
    }
  }

  cluster_endpoint_public_access = true

  tags = {
    Name      = concat(var.environment, "-eks")
    Terraform = "true"
    Env       = var.environment
  }
}

module "jenkins" {
  source = "./modules/jenkins"

  environment = var.environment
}
