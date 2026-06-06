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
  subnet_id = values(aws_subnet.public)[0].id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_ass" {
  for_each = aws_subnet.public
  route_table_id = aws_route_table.public_rt.id
  subnet_id = each.value.id

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_rt_ass" {
  route_table_id = aws_route_table.private_rt.id
  for_each = aws_subnet.private
  subnet_id = each.value.id
}