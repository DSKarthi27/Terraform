resource "aws_instance" "demo1-ec2" {
    ami = "ami-0c84181f02b974bc3"
    instance_type = "t2.micro"
    key_name = "firstserver"
    count = "1"
  vpc_security_group_ids = ["${aws_security_group.rtp03-sg.id}"]
   subnet_id = "${aws_subnet.private_subnet.id}"
   tags = {
     Name = "private"
   }
}
