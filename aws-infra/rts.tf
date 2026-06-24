# Route Tables

resource "aws_route_table" "to_igw" {
    vpc_id = aws_vpc.NatInstanceDemoVPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.NatInstanceDemoIGW.id
    }

    tags = {
        "Name" = "to_igw"
    }
}

resource "aws_route_table" "to_nat_instance" {
    vpc_id = aws_vpc.NatInstanceDemoVPC.id

    route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = aws_instance.nat_instance.primary_network_interface_id
    }
}
