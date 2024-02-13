variable "region" {
  type = string
}

variable "profile" {
  type = string
}
variable "vpc_name" {
  type = string

}

variable "vpc_cidr_block" {
  type = string

}

variable "ig" {
  type = string

}

variable "subnet_names" {
  type = list(string)

}

variable "subnet_cidr_blocks" {
  type = list(string)

}
variable "availability_zones" {
  type = list(string)

}

variable "public_subnet_name" {
  type = string
  
}

variable "public_subnet_cidr_block" {
  type = string
}
variable "public_subnet_availability_zone"{
  type = string
}