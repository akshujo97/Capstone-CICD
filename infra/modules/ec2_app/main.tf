data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

resource "aws_security_group" "app" {
  name   = "${var.name}-app-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-app-sg" }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  user_data = <<-EOT
    #!/bin/bash
    set -e
    yum update -y
    amazon-linux-extras enable docker
    yum install -y docker git
    systemctl enable docker
    systemctl start docker

    # Example placeholders (replace with your images or compose)
    # docker run -d -p 80:80 ghcr.io/your-org/resqpost-frontend:latest
    # docker run -d -p 5000:5000 ghcr.io/your-org/resqpost-backend:latest
  EOT

  tags = { Name = var.name }
}

output "public_ip" { value = aws_instance.app.public_ip }
output "sg_id"     { value = aws_security_group.app.id }
