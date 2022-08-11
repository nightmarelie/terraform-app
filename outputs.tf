output "ec2_public_ip" {
  value = module.dev-app-webserver.webserver.public_ip
}
