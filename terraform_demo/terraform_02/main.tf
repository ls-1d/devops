provider "aws" {
  region     = var.aws_region

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

resource "aws_vpc" "demo-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "demo-vpc-IGW"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo-igw.id
}

resource "aws_route_table_association" "public-subnet-1-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_eip" "nat-eip" {
  vpc = true
  tags = {
    Name = "nat-eip"
  }
}


resource "aws_key_pair" "aws-key-pair" {
  key_name   = "main-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQwJFoQoWndQQQyvCYggVCCO8HTHeigMFBNwfxdzSMv default_key"
}

resource "aws_security_group" "http_access" {
  name        = "http_access"
  description = "SG - http_access"
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "private-instance" {
  ami           = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private-subnet-1.id
  key_name = aws_key_pair.aws-key-pair.key_name

  tags = {
    Name = "private-instance"
  }
}

resource "aws_instance" "public-instance" {
  ami           = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.http_access.id ]
  key_name      = aws_key_pair.aws-key-pair.key_name

  tags = {
    Name = "public-instance"
  }
}
