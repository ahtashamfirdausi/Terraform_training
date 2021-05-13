provider "aws" {
  region = "eu-west-2"
}

module "myapp-subnet" {
  source = "../modules/network"
  env_prefix = var.env_prefix
  vpc_cidr_block = var.vpc_cidr_block
}