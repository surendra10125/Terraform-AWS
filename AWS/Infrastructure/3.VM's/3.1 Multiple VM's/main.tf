terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Define the provider with a region variable
provider "aws" {
  region  = var.region
  profile = var.profile
}

# Fetch VPC ID
data "aws_vpc" "my_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

#creation of security group 
resource "aws_security_group" "vm_security_group" {
  vpc_id = data.aws_vpc.my_vpc.id
  count = length(var.instance_names)
  name_prefix = var.instance_names[count.index]
/*  for_each = toset(var.instance_names)
  name     = "${each.key}-sg"*/
  description = "this security group belongs to ${var.instance_names[count.index]}"

  tags = {
    Name = "${var.instance_names[count.index]}-sg"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch subnet IDs
data "aws_subnet" "subnets" {
  count = length(var.subnets)

  filter {
    name   = "tag:Name"
    values = [element(var.subnets, count.index)]
  }
}

# Define instances
//noinspection ConflictingProperties
resource "aws_instance" "instance" {
  /*vpc_id = data.aws_vpc.my_vpc.id*/
  for_each      = { for idx, name in var.instance_names : idx => name }
  ami           = var.ami_id
  instance_type = var.instance_type[each.key]
  subnet_id     = data.aws_subnet.subnets[each.key].id
  vpc_security_group_ids = [aws_security_group.vm_security_group[each.key].id]
  key_name = var.key_pair_name

  tags = {
    Name = var.instance_names[each.key]
  }

  root_block_device {
    volume_size = var.volume_size
    tags = {
      Name= "${var.instance_names[each.key]}-root-disk "
    }
  }
  user_data = <<-EOF
                #!/bin/bash
                useradd -m ${var.vm_username}
                echo '${var.vm_username}:${var.vm_user_password}' | chpasswd
                sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
                systemctl restart sshd
                usermod -aG sudo ${var.vm_username}
              EOF
}