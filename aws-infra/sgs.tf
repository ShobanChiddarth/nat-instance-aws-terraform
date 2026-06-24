resource "aws_security_group" "bastion_sg" {
    vpc_id = aws_vpc.NatInstanceDemoVPC.id
    name = "bastion_sg"
    description = "allow SSH from my public IP"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ var.my_public_ip ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}
