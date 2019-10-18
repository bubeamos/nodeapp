# ecs.tf

resource "aws_ecs_cluster" "nodeapp-cluster" {
  name = "nodeapp-cluster"
}

# Task Definition Data 
data "template_file" "nodeapp" {
  template = file("./templates/ecs/node_app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    nodeapp_cpu    = var.nodeapp_cpu
    nodeapp_memory = var.nodeapp_memory
    aws_region     = var.aws_region
    aws_account_id = var.aws_account_id
  }
}


resource "aws_ecs_task_definition" "nodeapp_task_definition" {
  family                   = "nodeapp-service"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.nodeapp_cpu
  memory                   = var.nodeapp_memory
  container_definitions    = data.template_file.nodeapp.rendered
}


# ECS Service
resource "aws_ecs_service" "nodeapp-service" {
  name            = "nodeapp-service"
  cluster         = aws_ecs_cluster.nodeapp-cluster.id
  task_definition = aws_ecs_task_definition.nodeapp_task_definition.arn
  desired_count   = var.app_count
  launch_type     = "EC2"
  deployment_maximum_percent = var.max_healthy_percent
  deployment_minimum_healthy_percent = var.min_healthy_percent


  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nodeapp-target.id
    container_name   = "nodeapp-service"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.nodeapp_front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}