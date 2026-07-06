data "aws_vpc" "main" {
  id = "vpc-034be1ea92443a382"
}

data "aws_subnet" "jenkins" {
  id = "subnet-07e807d19df91f37c"
}

data "aws_subnet" "k3s" {
  id = "subnet-0c673dc48df5f3e59"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}