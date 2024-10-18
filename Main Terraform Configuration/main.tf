provider "aws" {
  region = var.region
}

# VPC Module
module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  vpc_name            = "my-vpc"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                 = ["us-west-2a", "us-west-2b"]
  create_nat_gateway  = true
}

# EC2 Module
module "ec2" {
  source         = "./modules/ec2"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = element(module.vpc.public_subnet_ids, 0)
  ami            = "ami-0c55b159cbfafe1f0"  # Example Amazon Linux 2 AMI
  instance_type  = "t2.micro"
  key_name       = var.key_name
  instance_name  = "my-ec2-instance"
}
