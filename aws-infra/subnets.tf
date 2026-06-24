resource "aws_subnet" "ManagementSubnet" {
    vpc_id = aws_vpc.NatInstanceDemoVPC.id
    cidr_block = "10.0.0.0/24"

    tags = {
      "Name" = "Management Subnet"
    }
}

resource "aws_route_table_association" "ManagementSubnetRTassoc" {
    subnet_id = aws_subnet.ManagementSubnet.id
    route_table_id = aws_route_table.to_igw.id
}
