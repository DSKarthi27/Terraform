
# Configure the AWS provider
provider "aws" {
  region     = "ap-south-1"  # Mumbai region
  access_key = "***************"
  secret_key = "********************"
}

# Create a security group for MySQL/Aurora
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-security-group"
  description = "Security group for MySQL/Aurora"

  // Inbound and outbound rule for MySQL/Aurora
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

# Create an RDS instance
resource "aws_db_instance" "example_rds" {
  identifier            = "example-db"
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "8.0.35"
  instance_class        = "db.t3.micro"
  username              = "admin"
  password              = "password"
  skip_final_snapshot   = true  # Set to true to skip final snapshot during deletion

  // Attach the security group to the RDS instance
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}

# Create an EC2 instance
resource "aws_instance" "example_ec2" {
  ami             = "ami-026255a2746f88074"  # Replace with your desired AMI
  instance_type   = "t2.micro"
  key_name        = "ABCD"
  user_data       = <<-EOF
                      #!/bin/bash
                      yum -y install mysql
                    EOF

  // Attach the security group to the EC2 instance
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "example-ec2"
  }
}

# Output public IP of the EC2 instance and RDS instance endpoint
output "ec2_public_ip" {
  value = aws_instance.example_ec2.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.example_rds.endpoint
}
