terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }

    awsutils = {
      source  = "cloudposse/awsutils"
      version = "~> 0.15"
    }
  }
}




module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.14.0"

    name = var.vpc_name
    cidr = var.vpc_cidr

    azs = var.vpc_azs
    private_subnets = var.vpc_private_subnets
    public_subnets = var.vpc_public_subnets

    enable_nat_gateway = var.vpc_enable_nat_gateway

    tags = var.vpc_tags
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"
  count   = 3

  name = "demo-ec2-cluster"

  ami                    = "ami-00c39f71452c08778"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "development"
  }
}