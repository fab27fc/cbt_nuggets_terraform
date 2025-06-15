resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "nginx_server" {
  ami                    = "ami-09e6f87a47903347c"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "nginx-server"
  }
}
