provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAR3P6VESRYDETI5NF"
  secret_key = "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"
}

resource "aws_security_group" "web_node" {
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

resource "aws_instance" "example-1" {
  ami           = "ami-0187337106779cdf8"
  instance_type = "t2.micro"
  key_name      = "windows"
  count         = "2"
  tags          ={
  Name="Karthi"
}
  security_groups = ["${aws_security_group.web_node.name}"]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}
