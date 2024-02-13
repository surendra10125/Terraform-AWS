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

variable "key_pair_name" {
  type = string
}
