provider "aws" {
  region = "ap-south-1"
  access_key = "**************"
  secret_key = "***************************"
}

resource "aws_instance" "example" {
  ami           = "ami-026255a2746f88074"
  instance_type = "t2.micro"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "CPUUtilizationHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU exceeds 70% for 5 consecutive periods"
  alarm_actions       = ["arn:aws:sns:ap-south-1:123456789012:MyTopic"]
  dimensions = {
    InstanceId = aws_instance.example.id
  }
}
