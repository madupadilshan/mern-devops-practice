# 1. අපි භාවිතා කරන්නේ AWS Cloud එක බව දැනුම් දීම
provider "aws" {
  region = "us-east-1"
}

# 2. අලුත්ම Ubuntu OS එක අන්තර්ජාලයෙන් සොයාගැනීම
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Ubuntu නිල ආයතනය (Canonical)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 3. Security Group (ආරක්ෂක Firewall එක) සෑදීම
resource "aws_security_group" "mern_sg" {
  name        = "mern-devops-sg"
  description = "Allow Web, SSH and Jenkins traffic"

  # අපිට Server එක ඇතුළට යන්න අවසර දීම (SSH - Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ලෝකෙටම අපේ Website එක බලන්න අවසර දීම (HTTP - Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend සහ Frontend වැඩ කිරීමට අවශ්‍ය Ports
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins වෙත පිවිසීම සඳහා අලුතින් විවෘත කළ Port එක (Port 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Server එකෙන් පිටතට යන දත්ත වලට අවසර දීම
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. ප්‍රධාන Server එක (EC2 Instance එක) සෑදීම
resource "aws_instance" "mern_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # AWS Free Tier එකෙන් නොමිලේ දෙන ප්‍රමාණය

  # ඉහතින් හැදූ Firewall එක මේ Server එකට සම්බන්ධ කිරීම
  vpc_security_group_ids = [aws_security_group.mern_sg.id]

  # Server එකට නමක් ලබා දීම
  tags = {
    Name = "MERN-DevSecOps-Server"
  }

  # ස්වයංක්‍රීයව මෘදුකාංග Install කිරීමේ කේතය (DevSecOps Automation - User Data)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y

              # 1. Java ස්ථාපනය (Jenkins සඳහා)
              sudo apt install fontconfig openjdk-17-jre -y

              # 2. Jenkins ස්ථාපනය
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install jenkins -y
              sudo systemctl start jenkins
              sudo systemctl enable jenkins

              # 3. Docker ස්ථාපනය (අපේ Images ධාවනය කිරීමට)
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker

              # Jenkins සහ සාමාන්‍ය පරිශීලකයාට Docker භාවිතා කිරීමට අවසර දීම
              sudo usermod -aG docker ubuntu
              sudo usermod -aG docker jenkins
              sudo systemctl restart docker
              EOF
}
