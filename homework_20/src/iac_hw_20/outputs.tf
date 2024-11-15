output "instance_ip" {
  description = "Instance ip. Module level"
  value       = aws_instance.nginx_instance.public_ip
}
