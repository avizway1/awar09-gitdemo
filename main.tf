
provider "aws" {
  region = var.region
  profile = "default"
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