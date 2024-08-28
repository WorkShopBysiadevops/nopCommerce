resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "eks-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "eks-route-table"
  }
}
resource "aws_route_table_association" "subnet_association" {
  for_each = {
    subnet1 = aws_subnet.public_subnet_1.id
    subnet2 = aws_subnet.public_subnet_2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}