# Get current public IP if not specified
data "http" "myip" {
    count = var.local_ip == "" ? 1 : 0
  url   = "http://ipv4.icanhazip.com"
}

locals {
  my_ip = var.local_ip != "" ? "${var.local_ip}/32" : "${chomp(data.http.myip[0].response_body)}/32"
}


resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "main-vpc" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az
  tags                    = merge(var.tags, { Name = "public-subnet" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "main-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { Name = "public-rt" })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from local machine"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from local IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "allow_ssh" })
}

resource "aws_instance" "web" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = var.ssh_key_name  # Critical for SSH access
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  
  tags = merge(var.tags, { Name = "web-server" })
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}