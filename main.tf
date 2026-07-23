
provider "aws" {
  region = var.region
  profile = "default"
}

terraform {
  cloud {
    organization = "aviz7"
    workspaces {
      name = "awar09-gitdemo"
  }
}
}

resource "aws_instance" "mumbai-webserver" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name        = "${var.environment}-server-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "aviz-hcp-test-23072026"
}
