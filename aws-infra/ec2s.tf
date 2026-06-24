locals {
    base_init = <<-EOF
    apt-get update
    apt-get upgrade -y
EOF
}

resource "aws_instance" "bastion" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.ManagementSubnet.id
    associate_public_ip_address = true
    user_data = local.base_init
    vpc_security_group_ids = [ aws_security_group.bastion_sg.id ]
    key_name = aws_key_pair.bastion_key_pair.key_name

    tags = {
      "Name" = "Bastion"
    }
}

