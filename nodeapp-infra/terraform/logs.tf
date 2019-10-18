# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "nodeapp_log_group" {
  name              = "/ecs/nodeapp"
  retention_in_days = 30

  tags = {
    Name = "nodeapp-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "nodeapp-stream" {
  name           = "nodeapp-stream"
  log_group_name = aws_cloudwatch_log_group.nodeapp_log_group.name
}

