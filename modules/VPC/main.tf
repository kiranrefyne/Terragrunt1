/*==== The VPC ======*/
resource "aws_vpc" "Refyne-UAT-VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.environment}-VPC"
    Environment = "${var.environment}"
  }
}

/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "Refyne-UAT-IGW" {
  vpc_id = "${aws_vpc.Refyne-UAT-VPC.id}"
  tags = {
    Name        = "${var.environment}-IGW"
    Environment = "${var.environment}"
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "Refyne-UAT-nat-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.Refyne-UAT-IGW]
}
/* NAT */
resource "aws_nat_gateway" "Refyne-UAT-NatGW" {
  allocation_id = "${aws_eip.Refyne-UAT-nat-eip.id}"
  subnet_id     = "${element(aws_subnet.Refyne-UAT-public-subnet.*.id, 0)}"
  depends_on    = [aws_internet_gateway.Refyne-UAT-IGW]
  tags = {
    Name        = "${var.environment}-nat"
    Environment = "${var.environment}"
  }
}

/* Public subnet */
resource "aws_subnet" "Refyne-UAT-public-subnet" {
  vpc_id                  = "${aws_vpc.Refyne-UAT-VPC.id}"
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr,count.index)}"
  availability_zone       = "${element(var.availability_zones,count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}

/* Private subnet */
resource "aws_subnet" "Refyne-UAT-private-subnet" {
  vpc_id                  = "${aws_vpc.Refyne-UAT-VPC.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr,count.index)}"
  availability_zone       = "${element(var.availability_zones,count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "Refyne-UAT-Route-Table-Public" {
  vpc_id = "${aws_vpc.Refyne-UAT-VPC.id}"
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "Refyne-UAT-Route-Table-Private" {
  vpc_id = "${aws_vpc.Refyne-UAT-VPC.id}"
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "Refyne-UAT-public_internet_gateway" {
  route_table_id         = "${aws_route_table.Refyne-UAT-Route-Table-Public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.Refyne-UAT-IGW.id}"
}
resource "aws_route" "Refyne-UAT-private_nat_gateway" {
  route_table_id         = "${aws_route_table.Refyne-UAT-Route-Table-Private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.Refyne-UAT-NatGW.id}"
}
/* Route table associations */
resource "aws_route_table_association" "Refyne-UAT-Public-Route-Association" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.Refyne-UAT-public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.Refyne-UAT-Route-Table-Public.id}"
}
resource "aws_route_table_association" "Refyne-UAT-Private-Route-Association" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.Refyne-UAT-private-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.Refyne-UAT-Route-Table-Private.id}"
}
