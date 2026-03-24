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
  description = "Allow Web and SSH traffic"

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
}
