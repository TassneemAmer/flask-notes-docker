resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.jenkins_instance_type
  key_name               = var.key_name
  subnet_id              = data.aws_subnet.jenkins.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false
  }

  user_data = file("${path.module}/scripts/jenkins.sh")

  tags = {
    Name = "terraform-jenkins-server"
  }
}

resource "aws_instance" "k3s" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.k3s_instance_type
  key_name               = var.key_name
  subnet_id              = data.aws_subnet.k3s.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false
  }

  user_data = file("${path.module}/scripts/k3s.sh")

  tags = {
    Name = "terraform-k3s-server"
  }
}