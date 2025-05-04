terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = var.region
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

 # Add this block to customize root volume
  root_block_device {
    volume_size = 100  # Size in GB
    volume_type = "gp3"
  }
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
      "sudo curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--disable traefik' sh -",
      "sudo sleep 5 && systemctl status k3s | grep -v k3s 2>/dev/null",
      "sudo curl -# -LO https://get.helm.sh/helm-v3.5.3-linux-amd64.tar.gz && sudo tar -xzvf helm-v3.5.3-linux-amd64.tar.gz",
      "sudo mv linux-amd64/helm /usr/local/bin/helm",
      "sudo helm version"
    ]
  }
  provisioner "remote-exec" {
  inline = [
    "sudo mkdir -p /root/.kube",
    "sudo cp /etc/rancher/k3s/k3s.yaml /root/.kube/config"
  ]
}
  provisioner "remote-exec" {
  inline = [
    "sudo helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx",
    "sudo helm repo update",
    "sudo helm install ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.extraArgs.update-status=\\\"false\\\""
  ]
}

  provisioner "file" {
    content     = self.public_ip
    destination = "/home/ubuntu/my_public_ip.txt"
  }
}
