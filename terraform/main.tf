terraform {
    required_providers {
    aws = {
        source = "harshicop/aws"
        version = "~>4.0"

    }
    }
    backend "s3" {
      key = "aws/ec2-deploy/terraform.tfstate"
    }
}

provider "aws"{
    region = var.region
}

resource "aws_instance" "server" {
    ami = "ami-089146c5626baa6bf"
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name 
    vpc_security_grouo_ids = [aws_security_grouo.maingroup.id]
    iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        pricate_key = var.parivate_key
        timeout = "4n"

    }
    tags = {
        "name" = "DeployVM"
    }
}
resource "aws_iam_instance_profile" "ec2-profile" {
    name = "ec2-profile"
    role = "ec2-ecr-auth"
}


resource "aws_security_group" "maingroup" {
    egress = [
        {
            cidr_blocks =["0.0.0.0/0"]
            description = ""
            from_port = 0
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "-1"
            security+group = []
            self = false 
            to_port = 0
        }
    ]
    ingress = {
        cidr_blocks =["0.0.0.0/0"]
            description = ""
            from_port = 22
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security+group = []
            self = false 
            to_port = 22
    },
    {
        cidr_blocks =["0.0.0.0/0"]
            description = ""
            from_port = 80
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security+group = []
            self = false 
            to_port = 80
    }
}

resource "aws_key_pair" "deployer"{
    key_name = var.key_name
    public_key = var.public_key
}

output "instance_public_ip" {
  value       = aws_iam_instance.server.public_ip
  sensitive   = true
}
# yes
