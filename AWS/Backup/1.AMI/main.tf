terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

# Define the provider with a region variable
provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_instances" "vms" {
  count = length(var.vm_ids)
/*
  instance_id  = var.vm_ids[count.index] # Using vm_ids if provided
*/
#  instance_names = var.instance_name[count.index]
}

resource "aws_ami_from_instance" "ami_instance" {
  name               = "var.instance_name[count.index]"
  source_instance_id = "i-{data.aws_instances.vms[count.index]}"
  snapshot_without_reboot = "true"
}