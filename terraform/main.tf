# Use AWS provider in us-east-1 region.
provider "aws" {
  region = "us-east-1"
}

# Security group for SSH, HTTP, and backend access.
resource "aws_security_group" "web_sg" {
  # Avoid duplicate-name failures when CI runs from a fresh state file.
  name_prefix = "mern-devops-sg-"
  description = "Allow SSH, HTTP, and Backend ports"

  # Allow SSH.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow backend API port.
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance for the app server.
resource "aws_instance" "app_server" {
  # Ubuntu 22.04 AMI.
  ami = "ami-0c7217cdde317cfec"
  # Free-tier friendly instance type.
  instance_type = "t2.micro"
  # Attach the security group.
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Install Docker and Docker Compose at startup.
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io docker-compose
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  # Name tag for the instance.
  tags = {
    Name = "MERN-DevSecOps-Server"
  }
}

# Output the public IP of the server.
output "server_public_ip" {
  value = aws_instance.app_server.public_ip
}
