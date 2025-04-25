# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

 # filter {
 #   name   = "name"
  #  values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
 # }

 # filter {
  #  name   = "virtualization-type"
  #  values = ["hvm"]
 # }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "instance_sg" {
  name_prefix = "instance-sg-"
  vpc_id      = "vpc-0f4386b65a536e8c3" # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your specific IP or 0.0.0.0/0 (less secure)
    description = "Allow SSH access from my IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-security-group"
  }
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
