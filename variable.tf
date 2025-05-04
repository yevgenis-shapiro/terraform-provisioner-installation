variable "region" {
  type = string
  default = "us-west-2"
}

variable "ec2_ami" {
  default = "ami-0345dd2cef523536e"
}

variable "ec2_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "ubuntu"
}
