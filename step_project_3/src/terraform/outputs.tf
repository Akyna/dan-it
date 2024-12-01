output "jenkins_master_instance_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_worker_instance_id" {
  value = aws_instance.jenkins_worker.private_ip
}
