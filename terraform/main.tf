# terraform/main.tf

# 1. Security Group එක සෑදීම (ආරක්ෂක නීති)
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

# --- අලුත් කොටස: ඔටෝමැටික් අලුත්ම Ubuntu AMI එක සොයාගැනීම ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) සමාගමේ නිල AWS ID එක

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. EC2 සර්වර් එක සෑදීම
resource "aws_instance" "mern_server" {
  ami           = data.aws_ami.ubuntu.id # Hardcode කළ අගය වෙනුවට dynamic අගය ලබාදීම
  instance_type = "t2.micro"
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

# 3. IP එක එළියට දීම (Pipeline එක සඳහා)
output "server_public_ip" {
  description = "අලුතින් සෑදූ EC2 සර්වර් එකේ IP ලිපිනය"
  value       = aws_instance.mern_server.public_ip
}
