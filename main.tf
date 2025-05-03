terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "tf-sec-gr" {
  name        = "tf-provisioner-sg"
  description = "Security group for terraform provisioner"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "tf-provisioner-sg"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ubuntu"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "instance" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_type
  key_name        = var.key_name
  security_groups = ["tf-provisioner-sg"]

  tags = {
    Name = "terraform-instance-provisioner"
  }

  provisioner "local-exec" {
    command = "echo http://${self.public_ip} > public_ip.txt"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")

  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo curl -sfL https://get.k3s.io | sh -",
      "sudo curl -# -LO https://get.helm.sh/helm-v3.5.3-linux-amd64.tar.gz && sudo tar -xzvf helm-v3.5.3-linux-amd64.tar.gz",
      "sudo mv linux-amd64/helm /usr/local/bin/helm",
      "sudo helm version"
    ]
  }

  provisioner "file" {
    content     = self.public_ip
    destination = "/home/ubuntu/my_public_ip.txt"
  }
}
