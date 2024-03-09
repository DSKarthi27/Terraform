provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAQXGUDW4CV6WPD5EF"
  secret_key = "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"
}

resource "aws_vpc" "my_vpc" {
  cidr_block             = "10.0.0.0/16"
  enable_dns_support     = true
  enable_dns_hostnames   = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_security_group" "web_node" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "web_node"
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami             = "ami-0187337106779cdf8"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "MyEC2Instance"
  }

  # Specify the dependency explicitly
  depends_on = [aws_security_group.web_node]

  security_groups = ["${aws_security_group.web_node.id}"]
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
}

