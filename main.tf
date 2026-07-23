
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

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.public_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "this" {
  bucket     = aws_s3_bucket.public_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.this]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.public_bucket.arn}/*"
    }]
  })
}
