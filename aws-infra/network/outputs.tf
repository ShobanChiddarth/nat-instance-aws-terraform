output "vpc_id" {
    value = aws_vpc.NatInstanceDemoVPC.id
}

output "vpc_cidr_block" {
    value = aws_vpc.NatInstanceDemoVPC.cidr_block
}

output "management_subnet_id" {
    value = aws_subnet.ManagementSubnet.id
}

output "private_subnet_id" {
    value = aws_subnet.PrivateSubnet.id
}

