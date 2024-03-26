provider "aws" {
  region = "ap-south-1"
  access_key = "**********************"
  secret_key = "******************************"
}

# Create a new security group
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an auto scaling group
resource "aws_autoscaling_group" "web_app" {
  launch_configuration = aws_launch_configuration.web.id
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  min_size             = 2
  max_size             = 2
  desired_capacity     = 2

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

# Create a launch configuration
resource "aws_launch_configuration" "web" {
  name                 = "web"
  image_id             = "ami-0187337106779cdf8"
  instance_type        = "t2.micro"
  security_groups      = ["${aws_security_group.web.name}"]
  key_name             = "ABCD"
  user_data            = <<-EOF
                         #!/bin/bash
                         yum update -y
                         yum install -y httpd
                         systemctl start httpd
                         systemctl enable httpd
                         EOF
}
