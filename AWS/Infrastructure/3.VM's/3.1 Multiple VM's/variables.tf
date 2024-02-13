# Define variables
variable "region"{
  default = "ap-south-1"
}
variable "profile" {
  type = string
}
variable "vpc_name"{
  type = string
}

variable "ami_id" {
  type = string 
  
}
variable "subnets" {
  type        = list(string)
  description = "List of subnet names"
}

variable "instance_names" {
  type        = list(string)
  description = "List of instance names"
}

variable "volume_size" {
  # type    = list(number)
  default = 30
}

variable "instance_type"{
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "vm_username" {
  type = string
}
variable "vm_user_password" {
  type = string
}
variable "key_pair_name" {
  type = string
}