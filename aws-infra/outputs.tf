output "bastion_public_ip" {
    value = aws_instance.bastion.public_ip
}

output "nat_instance_public_ip" {
    value = aws_eip.nat_instance_eip.public_ip
}

output "nat_instance_private_ip" {
    value = aws_instance.nat_instance.private_ip
}

output "PEC21_private_ip" {
    value = aws_instance.PEC21.private_ip
}

output "PEC22_private_ip" {
    value = aws_instance.PEC22.private_ip
}
