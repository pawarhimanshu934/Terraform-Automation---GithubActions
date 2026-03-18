output "vpc_id" {
  description = "Value of VPC ID"
  value = aws_vpc.my_vpc.id

}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = aws_subnet.public_subnet[*].id
}

output "load_balancer_DNS" {
    description = "DNS name of the load balancer"
    value = aws_lb.my_alb.dns_name
}

output "autoScaling_group-name" {
  description = "Name of autoscaling group"
  value = aws_autoscaling_group.my_asg.name
}