locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  private_subnets = [
    for az in local.availability_zones :
    cidrsubnet(var.vpc_cidr, 8, index(local.availability_zones, az))
  ]

  public_subnets = [
    for az in local.availability_zones :
    cidrsubnet(var.vpc_cidr, 8, index(local.availability_zones, az) + 100)
  ]
}
