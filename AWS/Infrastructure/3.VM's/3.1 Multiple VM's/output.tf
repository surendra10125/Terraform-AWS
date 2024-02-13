output "aws_security_group" {
  value = aws_security_group.vm_security_group.*.id
}

output "aws_security_name" {
  value = aws_security_group.vm_security_group.*.name
}