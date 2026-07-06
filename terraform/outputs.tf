output "jenkins_public_ip" {
  description = "Public IP of the Jenkins server"
  value       = aws_eip.jenkins_eip.public_ip
}

output "jenkins_public_dns" {
  description = "Public DNS of the Jenkins server"
  value       = aws_instance.jenkins.public_dns
}

output "k3s_public_ip" {
  description = "Public IP of the k3s server"
  value       = aws_instance.k3s.public_ip
}

output "k3s_public_dns" {
  description = "Public DNS of the k3s server"
  value       = aws_instance.k3s.public_dns
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "k3s_instance_id" {
  value = aws_instance.k3s.id
}