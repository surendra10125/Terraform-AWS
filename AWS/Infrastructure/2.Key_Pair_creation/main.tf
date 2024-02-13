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

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#create aws public keypair name
resource "aws_key_pair" "key_pair" {
  key_name = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

#create private key in local
resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.key_pair_name
}