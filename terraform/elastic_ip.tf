resource "aws_eip" "jenkins_eip" {
  domain = "vpc"

  tags = {
    Name = "terraform-jenkins-eip"
  }
}

resource "aws_eip_association" "jenkins_eip_assoc" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.jenkins_eip.id
}