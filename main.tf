variable "aws_region" {
  description = "The AWS region to deploy the resources to"
}

variable "aws_creds_file" {
  description = "The full path to the .aws/credentials file"
}

variable "aws_profile" {
  description = "The profile in the credentials file to use"
}

variable "aws_pem" {
  description = "The PEM file to use for SSH. This is outputted with the IP for convenience"
}

variable "ssh_key" {
  description = "The AWS Key Pair to use for SSH"
}

provider "aws" {
  region                  = var.aws_region
  profile                 = var.aws_profile
}

data "http" "myip" {
  url = "https://api.ipify.org"
}

data "aws_availability_zones" "all" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_vpc" "temp-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy     = "default"

  tags = {
    Name = "temp-vpc"
  }
}

resource "aws_subnet" "temp-subnet" {
  vpc_id                  = aws_vpc.temp-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" #it makes this a public subnet
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "temp-subnet"
  }
}

resource "aws_internet_gateway" "temp-igw" {
  vpc_id = aws_vpc.temp-vpc.id
  tags = {
    Name = "temp-igw"
  }
}

resource "aws_route_table" "temp-rtble" {
  vpc_id = aws_vpc.temp-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.temp-igw.id
  }

  tags = {
    Name = "temp-rtble"
  }
}

resource "aws_route_table_association" "temp-rta" {
  subnet_id      = aws_subnet.temp-subnet.id
  route_table_id = aws_route_table.temp-rtble.id
}

resource "aws_security_group" "temp-sg" {
  name   = "temp-sg"
  vpc_id = aws_vpc.temp-vpc.id
}

resource "aws_security_group_rule" "temp-sg-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  security_group_id = aws_security_group.temp-sg.id
}

resource "aws_security_group_rule" "temp-sg-rdp" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  security_group_id = aws_security_group.temp-sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.temp-sg.id
}

resource "aws_instance" "temp-workstation" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.xlarge"
  key_name               = var.ssh_key
  vpc_security_group_ids = [aws_security_group.temp-sg.id]
  subnet_id              = aws_subnet.temp-subnet.id
  user_data              = file("temp-workstation.sh")
  tags = {
    Name = "temp-workstation"
  }
}

output "ssh_connection_string" {
  value = "ssh -i ${var.aws_pem} ubuntu@${aws_instance.temp-workstation.public_ip}"
}

output "RDP_address" {
  value = aws_instance.temp-workstation.public_ip
}

output "RDP_UserName" {
  value = "shokz"
}

output "RDP_Password" {
  value = "Changemenow"
}
