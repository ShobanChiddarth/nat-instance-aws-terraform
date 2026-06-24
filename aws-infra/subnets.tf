resource "aws_subnet" "ManagementSubnet" {
    vpc_id = aws_vpc.NatInstanceDemoVPC.id
    cidr_block = "10.0.0.0/24"

    tags = {
      "Name" = "ManagementSubnet"
    }
}

resource "aws_route_table_association" "ManagementSubnetRTassoc" {
    subnet_id = aws_subnet.ManagementSubnet.id
    route_table_id = aws_route_table.to_igw.id
}


resource "aws_subnet" "PrivateSubnet" {
    vpc_id = aws_vpc.NatInstanceDemoVPC.id
    cidr_block = "10.0.1.0/24"

    tags = {
      "Name" = "PrivateSubnet"
    }
}

resource "aws_route_table_association" "PrivateSubnetRTassoc" {
    subnet_id = aws_subnet.PrivateSubnet.id
    route_table_id = aws_route_table.to_nat_instance.id
}
