resource "aws_instance" "ec2-instance" {
  ami             = data.aws_ami.ami.image_id 
  key_name        = var.key_pair  
  instance_type   = var.instance_type_medium
  subnet_id       = var.subnet_id   
  iam_instance_profile = aws_iam_instance_profile.instance-profile.name
  security_groups = [aws_security_group.jump-server-sg.name]
  user_data       = templatefile("../jump-server/install-tools.sh", {})
  monitoring      = true

  root_block_device {
    volume_size = 8
  }
         
  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "jump-server-sg" {
  name      = "jump-server-sg"
  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress  {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = "Jumper-server-profile"
  role = aws_iam_role.iam-role.name
}

resource "aws_iam_role" "iam-role" {
  name               = var.iam-role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}