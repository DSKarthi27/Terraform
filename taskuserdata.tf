provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAUYDQCNHCIM5Z5U6B"
  secret_key = "rv6hFpkyAY/s+2A3PZESkrnj6Ojhm68tskpwacRD"
}

resource "aws_security_group" "aabbcc" {
    name        = "aabbcc"
    description = "example security group"
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

resource "aws_instance" "example-1" {
  ami           = "ami-0187337106779cdf8"
  instance_type = "t2.micro"
  key_name = "balakuben"
  count = "2"
  security_groups = ["${aws_security_group.aabbcc.name}"]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}
