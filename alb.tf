resource "aws_lb" "my_alb" {
  name               = "my-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name        = "my-alb-${var.environment}"
    Environment = var.environment
  }

}

resource "aws_lb_target_group" "my_alb_target_group" {
  name     = "my-alb-target-group-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "my-alb-target-group-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_alb_target_group.arn
  }
}