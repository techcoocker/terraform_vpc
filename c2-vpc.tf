resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  for_each ={for index, az in local.azs : az => local.public_subnet[index]} 
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc.id
  for_each = {for index, az in local.azs : az => local.private_subnet[index]}
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = false
}

resource "aws_eip" "eip" {
  domain = "vpc"

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = local.public_subnet
}