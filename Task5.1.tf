
// Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.rtp03-vpc.id}"
  cidr_block              = "10.0.0.128/25"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags = {
    name = "privatesubnet"
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = "${aws_vpc.rtp03-vpc.id}"
}

# Associate Private Subnet with Route Table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

# EIP for NAT Gateway
resource "aws_eip" "CustomEIP" {

  tags = {
    "Name" = "CustomEIP"
  }
}
resource "aws_nat_gateway" "CustomNAT" {
  allocation_id = aws_eip.CustomEIP.id
  subnet_id = "${aws_subnet.rtp03-public_subnet_01.id}"
  tags = {
    Name = "CustomNAT"
  }
}
# Route for NAT Gateway
resource "aws_route" "private_subnet_nat_gateway_route" {
  route_table_id         = aws_route_table.private_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.CustomNAT.id

}
    
