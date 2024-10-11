
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "igw-tf"
  }
}

resource "aws_subnet" "public_tf" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/28"  # This is your public subnet
  tags = {
    Name = "public-tf"
  }
}

resource "aws_subnet" "private_tf" {
  vpc_id              = aws_vpc.my_vpc.id
  cidr_block          = "10.0.0.16/28" # First private subnet
  availability_zone   = "us-east-1a"

  tags = {
    Name = "private_tf"
  }
}

resource "aws_subnet" "private_tf1" {
  vpc_id              = aws_vpc.my_vpc.id
  cidr_block          = "10.0.0.32/28" # Second private subnet
  availability_zone   = "us-east-1b"

  tags = {
    Name = "private_tf1"
  }
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name : "Public_rtf"
  }
}
resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.public_tf.id
  route_table_id = aws_route_table.table.id
}
resource "aws_eip" "name" {

}
resource "aws_nat_gateway" "nat" {
  connectivity_type = "public"
  allocation_id     = aws_eip.name.id
  subnet_id         = aws_subnet.public_tf.id
  tags = {
    Name : "nat-tf"
  }
}
resource "aws_route_table" "private_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name : "private_rtf"
  }
}
resource "aws_route_table" "private_table1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name : "private_rtf1"
  }
}
resource "aws_route_table_association" "pvt" {
  subnet_id      = aws_subnet.private_tf.id
  route_table_id = aws_route_table.private_table.id
}
resource "aws_route_table_association" "pvt1" {
  subnet_id      = aws_subnet.private_tf1.id
  route_table_id = aws_route_table.private_table1.id
}
