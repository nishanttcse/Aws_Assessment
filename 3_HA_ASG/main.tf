provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_subnet" "public1" {
  id = var.public_subnet_ids[0]
}

data "aws_subnet" "public2" {
  id = var.public_subnet_ids[1]
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.prefix}_ec2_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "iprof" {
  name = "${var.prefix}_iprof"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}_alb_sg"
  description = "Allow HTTP from internet"
  vpc_id      = data.aws_subnet.public1.vpc_id

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

  tags = {
    Name = "${var.prefix}_alb_sg"
  }
}

resource "aws_security_group" "private_web" {
  name   = "${var.prefix}_private_web_sg"
  vpc_id = data.aws_subnet.public1.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}_private_web_sg"
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${var.prefix}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.iprof.name
  }

  user_data = base64encode(file("${path.module}/../2_EC2_Static_Website/setup_nginx.sh"))

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_web.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix}_lt_instance"
    }
  }
}
resource "aws_lb" "alb" {
  name               = "${replace(var.prefix, "_", "-")}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix}_alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "${replace(var.prefix, "_", "-")}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_subnet.public1.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200-399"
  }

  tags = {
    Name = "${var.prefix}_tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.prefix}-asg"
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [aws_lb_target_group.tg.arn]
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}_asg_instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
