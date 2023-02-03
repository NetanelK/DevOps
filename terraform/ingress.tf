resource "aws_security_group" "lb_sg" {
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow ALB 80 traffic"
    from_port        = 80
    protocol         = "tcp"
    self             = false
    to_port          = 80
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "app_sg" {
  ingress {
    description     = "Allow 5000 traffic from ALB"
    from_port       = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
    self            = false
    to_port         = 5000
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_lb" "this" {
  name = "flask-alb"

  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "backend" {
  port     = 5000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path    = "/health"
    matcher = "200"
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
