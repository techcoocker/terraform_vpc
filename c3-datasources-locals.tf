data "aws_availability_zone" "avaiable" {
  state = "available"
}

locals {
  azs=slice(data.aws_availability_zone.avaiable.name,0,2)
  public_subnet=[for k, az in local.azs : cidrsubnet(var.cidr,var.newbits,k)]
  private_subnet=[for k, az in local.azs : cidrsubnet(var.cidr,var.newbits,k+10)]
}