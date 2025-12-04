provider "aws" { region = var.region }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "${var.prefix}_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "${var.prefix}_web_sg"
  description = "Allow HTTP and SSH from my IP"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "selected" {
  id = var.public_subnet_id
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id
  key_name      = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = file("setup_nginx.sh")

  tags = { Name = "${var.prefix}_ec2_web" }
}

output "public_ip" { value = aws_instance.web.public_ip }
