variable "vpc_name" {
  type    = string
  default = "flask-vpc"
}

variable "az_count" {
  type    = number
  default = 2
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "asg_min_size" {
  type    = number
  default = 0
}

variable "asg_max_size" {
  type    = number
  default = 1
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}

variable "image_repo" {
  type    = string
  default = "public.ecr.aws/l0s8g3f4/flask-app"
}

variable "image_tag" {
  type    = string
  default = "latest"
}
