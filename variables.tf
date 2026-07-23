variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0b910d1016287a5e7"
}


variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type    = string
  default = "awar10-lnx-kp"
}

variable "environment" {
  type = string
}