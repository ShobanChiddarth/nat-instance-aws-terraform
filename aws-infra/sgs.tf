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

resource "aws_security_group" "PEC2_sg" {
    name = "PEC2_sg"
    vpc_id = aws_vpc.NatInstanceDemoVPC.id
    description = "allow ssh from bastion"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.bastion_sg.id ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}
