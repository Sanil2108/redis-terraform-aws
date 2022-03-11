

resource "aws_security_group" "instance_security_group" {
  name        = "Main instance security group"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Redis"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "main-instance" {
  ami = "ami-0e0ff68cb8e9a188a"
  associate_public_ip_address = true
  instance_type = "t3.micro"
  key_name = "current-main-kp"
  vpc_security_group_ids = [ aws_security_group.instance_security_group.id ]
  subnet_id = var.subnet_id
  user_data = var.user_data

  tags = {
    Name = "main_instance"
  }
}
