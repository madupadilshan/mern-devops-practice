# Security group for SSH, frontend HTTP, and backend API access.
resource "aws_security_group" "mern_sg" {
  name        = "mern-app-sg"
  description = "Allow HTTP, Backend, and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Resolve the latest Ubuntu 22.04 AMI dynamically.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Official Canonical AWS account ID.

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 instance for running the MERN containers.
resource "aws_instance" "mern_server" {
  ami           = data.aws_ami.ubuntu.id # Use the latest image from the data source.
  instance_type = "t3.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.mern_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "MERN-DevSecOps-Server"
  }
}

# Export public IP for CI/CD deployment steps.
output "server_public_ip" {
  description = "Public IP address of the created EC2 instance"
  value       = aws_instance.mern_server.public_ip
}
