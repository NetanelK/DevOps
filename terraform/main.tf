data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ami" "amazon-linux" {
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  most_recent = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = local.availability_zones
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.7.1"

  name                = "flask-asg"
  vpc_zone_identifier = module.vpc.private_subnets

  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_capacity
  max_size         = var.asg_max_size

  target_group_arns = [aws_lb_target_group.backend.arn]

  image_id          = data.aws_ami.amazon-linux.id
  instance_type     = "t2.micro"
  health_check_type = "ELB"
  security_groups   = [aws_security_group.app_sg.id]

  create_iam_instance_profile = true
  iam_role_name               = "FlaskASGManage"
  iam_role_path               = "/ec2/"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user

    docker run -d -p 5000:5000 ${var.image_repo}:${var.image_tag}  
  EOF
  )
}
