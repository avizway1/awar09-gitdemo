terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.55.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket       = "aviz.tf.state.myproject"
    key          = "projectx/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["MY-APP-CVPC"]
  }
}

data "aws_subnet" "existing_subnet" {
  filter {
    name   = "tag:Name"
    values = ["CVPC-WEB-1A"]
  }
}


data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
}

locals {
  ingress_rules = [
    { port = 22 },
    { port = 80 }
  ]
}

resource "aws_security_group" "with_dynamic" {
  name        = "manual-with-dynamic"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = data.aws_vpc.existing_vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


resource "aws_instance" "mumbai-webserver" {
  ami                    = data.aws_ami.al2023.id
  subnet_id              = data.aws_subnet.existing_subnet.id
  instance_type          = "t3.micro"
  key_name               = "awar10-lnx-kp"
  vpc_security_group_ids = [aws_security_group.with_dynamic.id]
  tags = {
    Name = "mumbai-WebServer"
  }
}

resource "aws_s3_bucket" "myfirstbucket" {
  bucket = "aviz-terraform-bucket-15072026"
}