provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0b910d1016287a5e7"
  instance_type = "t3.small"

  tags = {
    Name = "WebServer"
  }
}

resource "aws_s3_bucket" "myfirstbucket" {
  bucket = "aviz-terraform-bucket-15072026"
}

output "instance_id" {
  description = "The ID of the webserver instance"
  value       = aws_instance.webserver.id
}

output "instance_public_ip" {
  description = "The public IP address of the webserver instance"
  value       = aws_instance.webserver.public_ip
  sensitive   = true
}

output "mys3bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.myfirstbucket.id
}