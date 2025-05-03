output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.instance.public_ip
}
