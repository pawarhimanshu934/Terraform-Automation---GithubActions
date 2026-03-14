#Creating Launch Template for EC2

resource "aws_launch_template" "launch_template" {
  name_prefix   = "my-app-${var.environment}"
  image_id      = var.image_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app-sg.id]

  user_data = filebase64("${path.module}/scripts/user_data.sh")

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "EC2-Instance-${var.environment}"
      Environment = var.environment
    }

  }
}

resource "aws_autoscaling_group" "my_asg" {
    name = "my-asg-${var.environment}"
    desired_capacity = 2
    max_size = 5
    min_size = 1

    vpc_zone_identifier = aws_subnet.private_subnet[*].id

    target_group_arns = [aws_lb_target_group.my_alb_target_group.arn]

    health_check_type = "ELB"

    health_check_grace_period = 300


    launch_template {
      id = aws_launch_template.launch_template.id
      version = "$Latest"
    }

    tag {
      key = "Name"
      value = "asg-instance"
      propagate_at_launch = true
    }
  
}

#Scale Out Policy (Add Instances), When triggered -> add 1 instance
resource "aws_autoscaling_policy" "scale_up" {
  name = "scale-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

#Scale In Policy (Remove Instances), When triggered -> remove 1 instance
resource "aws_autoscaling_policy" "scale_in" {
  name = "scale_in"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

#Smart Scaling policy, automatically scale up and in based on CPU utilization
resource "aws_autoscaling_policy" "target-tracking" {
  name = "target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }

}






# target_group_arns connects your Auto Scaling Group to the Load Balancer target group. 
# Without this, the load balancer does not know where to send traffic.

# What happens when you add it:

# ASG launches EC2 instances

# Instances automatically register into the LB's target group

# Load balancer sends traffic to those instances