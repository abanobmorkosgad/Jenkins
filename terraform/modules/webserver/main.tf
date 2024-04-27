resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id

  ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp" 
        cidr_blocks      = [var.myip]
    }

    ingress {
        from_port       = 8080
        to_port         = 8080
        protocol        = "tcp" 
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        prefix_list_ids = [] 
    }

    tags = {
        Name = "${var.env_prefix}-SG"
    }
}

data "aws_ami" "latest-amzn-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values =  ["al2023-ami-2023.*-x86_64"]
  } 
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.latest-amzn-linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  user_data = file("./entry-script.sh")
  key_name = "terraform"

  tags = {
    Name = "${var.env_prefix}-EC2"
  }
}