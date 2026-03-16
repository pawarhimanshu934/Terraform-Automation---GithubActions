#Creating Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name = "alb-sg-${var.environment}"
  description = "Security group for ALB"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "alb-sg-${var.environment}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb-inbound" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "alb-outbound" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

#Creating Security Group for Launch Template

resource "aws_security_group" "app-sg" {
    name = "app-sg-${var.environment}"
    description = "Security group for launch template"
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      name = "app-sg-${var.environment}"
    }
  
}

resource "aws_vpc_security_group_ingress_rule" "app-inbound" {
    security_group_id = aws_security_group.app-sg.id
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
    referenced_security_group_id = aws_security_group.alb_sg.id

}

resource "aws_vpc_security_group_ingress_rule" "app-inbound-22" {
    security_group_id = aws_security_group.app-sg.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_ipv4 = "0.0.0.0/0"

}

resource "aws_vpc_security_group_egress_rule" "app-outbound" {
    security_group_id = aws_security_group.app-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
  
}
