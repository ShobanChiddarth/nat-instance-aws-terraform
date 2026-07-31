resource "aws_vpc" "NatInstanceDemoVPC" {
    cidr_block = "10.0.0.0/16"

    tags = {
      "Name" = "NatInstanceDemoVPC"
    }
}

resource "aws_internet_gateway" "NatInstanceDemoIGW" {
    vpc_id = aws_vpc.NatInstanceDemoVPC.id

    tags = {
      "Name" = "NatInstanceDemoIGW"
    }
}
