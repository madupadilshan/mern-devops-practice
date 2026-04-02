# terraform/main.tf

# 1. Docker Images ගබඩා කිරීමට ECR Repositories සෑදීම
resource "aws_ecr_repository" "backend_repo" {
  name                 = "mern-backend"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "frontend_repo" {
  name                 = "mern-frontend"
  image_tag_mutability = "MUTABLE"
}

# 2. Security Group එක සෑදීම (ආරක්ෂක නීති)
resource "aws_security_group" "mern_sg" {
  name        = "mern-app-sg"
  description = "Allow HTTP, Backend, and SSH traffic"

  # SSH සඳහා (ඔබට අවශ්‍ය නම් මෙහි "0.0.0.0/0" වෙනුවට ඔබගේ IP එක පමණක් ලබාදිය හැක - Best Practice)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend එක සඳහා (Web Traffic)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend API එක සඳහා
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # පිටතට යන ඕනෑම ට්‍රැෆික් එකකට ඉඩ දීම
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. EC2 සර්වර් එක සෑදීම
resource "aws_instance" "mern_server" {
  ami           = "ami-0c7217cdde317cfec" # මෙය Ubuntu 22.04 LTS (us-east-1) වලට අදාල AMI ID එකකි.
  instance_type = "t3.micro" # Free tier
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.mern_sg.id]

  # සර්වර් එක on වන විටම ස්වයංක්‍රීයව Docker install වීමට කේතය (Automation)
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

output "server_public_ip" {
  description = "අලුතින් සෑදූ EC2 සර්වර් එකේ IP ලිපිනය"
  value       = aws_instance.mern_server.public_ip
}
