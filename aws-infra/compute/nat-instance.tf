# Modularise the whole NAT instance in a singla .tf file

# Dependencies
# - Ubuntu AMI via `data.aws_ami.ubuntu.id`
# - `subnet_id`
# - edit the security group appropriately

locals {
    nat_instance_init = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get upgrade -y
    set -eux

    export DEBIAN_FRONTEND=noninteractive

    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

    apt-get install -y iptables-persistent

    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-nat.conf

    PRIMARY_IFACE=$(ip route | awk '/default/ {print $5; exit}')

    iptables -t nat -A POSTROUTING -o "$PRIMARY_IFACE" -j MASQUERADE
    iptables -A FORWARD -i "$PRIMARY_IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -o "$PRIMARY_IFACE" -j ACCEPT

    netfilter-persistent save
EOF
}


resource "aws_security_group" "nat_instance_sg" {
    name = "nat_instance_sg"
    vpc_id = var.vpc_id
    description = "allow everything"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.bastion_sg.id ]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ var.vpc_cidr_block ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}


resource "aws_instance" "nat_instance" {
    ami = data.aws_ami.ubuntu.id # hard dependency
    instance_type = "t3.micro"
    subnet_id = var.management_subnet_id
    # associate_public_ip_address = true
    user_data = local.nat_instance_init
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

    # depends_on = [ aws_internet_gateway.NatInstanceDemoIGW ] # make compute module depend on network module
}


resource "aws_route_table" "to_nat_instance" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = aws_instance.nat_instance.primary_network_interface_id
    }

    depends_on = [ aws_eip.nat_instance_eip ]
}


resource "aws_route_table_association" "private_to_nat_instance" {
    subnet_id = var.private_subnet_id
    route_table_id = aws_route_table.to_nat_instance.id
}
