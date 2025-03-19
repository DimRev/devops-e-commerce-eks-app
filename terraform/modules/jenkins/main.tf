data "aws_ami" "jenkins_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.jenkins_ami.image_id
  instance_type = "t3.medium"

  tags = {
    Name      = concat(var.environment, "-jenkins-e-commerce")
    Terraform = "true"
    Env       = var.environment
  }
}
