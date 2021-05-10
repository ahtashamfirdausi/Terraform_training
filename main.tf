provider "aws" {
    region = "eu-west-2"
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}

resource "aws_vpc" "aws_vpc"{
    cidr_block = var.vpc_cider_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1"{
    vpc_id = aws_vpc.aws_vpc.id
    cridr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}