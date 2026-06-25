locals {
    base_init = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get upgrade -y
EOF

    nat_instance_init = <<-EOF
    set -eux

    apt-get install -y iptables-persistent

    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-nat.conf
    sysctl --system

    PRIMARY_IFACE=$(ip route | awk '/default/ {print $5; exit}')

    iptables -t nat -A POSTROUTING -o "$PRIMARY_IFACE" -j MASQUERADE
    iptables -A FORWARD -i "$PRIMARY_IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -o "$PRIMARY_IFACE" -j ACCEPT

    netfilter-persistent save
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

resource "aws_instance" "PEC21" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.PrivateSubnet.id
    associate_public_ip_address = false
    user_data = local.base_init
    vpc_security_group_ids = [ aws_security_group.PEC2_sg.id ]
    key_name = aws_key_pair.management_key_pair.key_name

    tags = {
      "Name" = "PEC21"
    }
}

resource "aws_instance" "PEC22" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.PrivateSubnet.id
    associate_public_ip_address = false
    user_data = local.base_init
    vpc_security_group_ids = [ aws_security_group.PEC2_sg.id ]
    key_name = aws_key_pair.management_key_pair.key_name

    tags = {
      "Name" = "PEC22"
    }
}


resource "aws_instance" "nat_instance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.ManagementSubnet.id
    # associate_public_ip_address = true
    user_data = join("\n", [local.base_init, local.nat_instance_init])
    vpc_security_group_ids = [ aws_security_group.nat_instance_sg.id ]
    key_name = aws_key_pair.management_key_pair.key_name
    source_dest_check = false

    tags = {
      "Name" = "NAT_instance"
    }
}

resource "aws_eip" "nat_instance_eip" {
     instance = aws_instance.nat_instance.id
     domain = "vpc"

     tags = {
       "Name" = "nat_instance_eip"
     }

     depends_on = [ aws_internet_gateway.NatInstanceDemoIGW ]
}
