data "aws_ami" "jenkins_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "template_file" "jenkins_userdata" {
  template = file("${path.module}/templates/jenkins_userdata.tpl")
}

resource "aws_eip" "jenkins_ip" {
  tags = {
    Name      = "${var.environment}-${var.app_name}-jenkins-eip"
    Terraform = "true"
    Env       = var.environment
  }
}

resource "aws_eip_association" "jenkins_eip_assoc" {
  allocation_id = aws_eip.jenkins_ip.id
  instance_id   = aws_instance.jenkins.id
}


#############################
# EC2 Instance
#############################
resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.jenkins_ami.image_id
  instance_type = "t3.medium"

  user_data = base64encode(data.template_file.jenkins_userdata.rendered)

  key_name = var.key_pair_name
  vpc_security_group_ids = [
    aws_security_group.jenkins_sg.id
  ]
  subnet_id = var.subnet_id
  tags = {
    Name      = "${var.environment}-${var.app_name}-jenkins-ec2"
    Terraform = "true"
    Env       = var.environment
  }
}

#############################
# Security Group
#############################

resource "aws_security_group" "jenkins_sg" {
  name        = "${var.environment}-${var.app_name}-jenkins-sg"
  description = "Security group for Jenkins"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.environment}-${var.app_name}-jenkins-sg"
    Terraform = "true"
    Env       = var.environment
  }
}
