variable "region" {}
variable "profile" {}
variable "vm_ids" {
  type    = list(string)
  default = []
}
variable "instance_name" {
  type = list(string)
}