output "aws_ami" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_public_ip" {
  value = aws_instance.dev-app-server.public_ip
}
