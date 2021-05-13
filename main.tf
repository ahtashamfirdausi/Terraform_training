provider "aws" {
    region = "eu-west-2"
}
resource "aws_vpc" "myapp-vpc"{
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}
module "myapp-subnet" {
    source = "./modules/subnet"   // . is for current directory
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  
}
 module "myapp-server"{
     source = "./modules/webserver"

      vpc_id =
      my_ip  =
      env_prefix =
      image_name =
      public_key_location =
      instance_type =
      subnet_id =  
      sg_id =  
      avail_zone =
      env_prefix =

 } 