# alb.tf

resource "aws_alb" "nodeapp" {
  name            = "nodeapp-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "nodeapp-target" {
  name        = "cb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  deregistration_delay = 180

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "nodeapp_front_end" {
  load_balancer_arn = aws_alb.nodeapp.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener
resource "aws_alb_listener" "nodeapp_https_front_end" {
  load_balancer_arn = aws_alb.nodeapp.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_arn

  default_action {
    target_group_arn = aws_alb_target_group.nodeapp-target.id
    type             = "forward"
  }
}


resource "aws_route53_record" "nodeapp_record" {
  zone_id = var.aws_route53_zone
  name    = var.dns_record
  type    = "A"

  alias {
    name                   = aws_alb.nodeapp.dns_name 
    zone_id                = aws_alb.nodeapp.zone_id
    evaluate_target_health = false
  }
}