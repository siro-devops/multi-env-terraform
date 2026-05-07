provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "siro-devops-terraform-state"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc" {
  source              = "../../modules/vpc"
  env                 = "staging"
  cidr_block          = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
  region              = "us-east-1"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
