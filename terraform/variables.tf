variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "instance_type" {
  description = "Default EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Jenkins EC2 instance type"
  type        = string
}

variable "k3s_instance_type" {
  description = "k3s EC2 instance type"
  type        = string
}
