provider "aws" {
  region = "ap-south-1" # Mumbai, change as needed
}

# Security group allowing SSH and HTTP
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub") 
}


resource "aws_instance" "web" {
  ami           = "ami-02d26659fd82cf299" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "Terraform-EC2"
  }
}
