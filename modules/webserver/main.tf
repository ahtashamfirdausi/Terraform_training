# To use default security group we have to simple change the name to default in resource block and in
# name block we have to skip it.

resource  "aws_security_group" "myapp-sg" {  
    name = "myapp-sg"
    vpc_id =var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
   ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
}
tags = {

    Name: "${var.env_prefix}-sg"
}
}
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = [var.image_name]
    }
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_key_pair" "ssh-key" {
 key_name = "server-key"
  public_key =  file(var.public_key_location)                       
}

 resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id =  var.subnet_id               //  module.myapp-subnet.subnet.id resource of the child module - subnet output value return values of module,
    vpc_security_group_ids = [var.sg_id]
    availability_zone =  var.avail_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name

    user_data = file("entry-script.sh")

     tags = {

         Name: "${var.env_prefix}-server"

   }
 }


   # for running the script user_data is better option tha provisioner 
   # provisioner concept actually breaks the concept of idempotency in terraform.
   # user_data = file("entry-script.sh")
   
  /* connection {
       type = "ssh"
       host = self.public_ip
       user = "ec2-user"
       private_key = file(var.private_key_location)
     
   }
  


    # "remote-exec" provisioner
    # invokes script on a remote resource after it is created
    # inline - list of commnds
    # script-path

    # copying entry-script.sh file form local machine to remote server.
    provisioner "file" {
        source = "entry-scrpit.sh"
        destination = "/home/ec2-user/entry-scrpit-on-ec2.sh"
    
    }

    provisioner "remote-exec" {
        script = file("entry-script-on-ec2.sh")
    
    }
    # "local-exec" provisioner
    # invoke a local executable afetr a resource is created.

    provisioner "local-exec" {
        commnd = "echo ${self.public_ip} > output.txt"
    
    }



# one way to provisioner remote
   /* provisioner "remote-exec" {
        inline = [
            "export ENV=dev",
            "mkdir newdir"

        ]
    
    }*/

   