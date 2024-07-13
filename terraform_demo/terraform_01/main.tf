provider "aws" {
  region     = "us-east-1"

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

resource "aws_default_vpc" "default_vpc" {

}

resource "aws_security_group" "aws_sg" {
  name = "security group from terraform"

  # ingress {
  #   description = "SSH from the internet"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "terraform-key" {
  key_name   = "main_ed2"
  public_key = file("~/.ssh/main_ed2.pub")
}

resource "aws_instance" "aws_ins_web_00" {
  ami                         = "ami-0a0e5d9c7acc336f1"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.aws_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.terraform-key.key_name

  tags = {
    Name = "ubuntu-instance_00"
  }
}

resource "aws_instance" "aws_ins_web_01" {
  ami                         = "ami-0a0e5d9c7acc336f1"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.aws_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.terraform-key.key_name

  tags = {
    Name = "ubuntu-instance_01"
  }
}

# output "instance_ip" {
#   value = aws_instance.aws_ins_web.public_ip
# }
