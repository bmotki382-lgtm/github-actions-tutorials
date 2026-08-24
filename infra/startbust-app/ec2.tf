resource "aws_instance" "public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnet_ids["public-1"]
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = "Marutikey"
  iam_instance_profile        = aws_iam_instance_profile.test_profile.name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("/Users/sonu/Downloads/Marutikey.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}


resource "aws_instance" "private" {

  for_each = {
    private-1 = module.vpc.private_subnet_ids["private-1"]
    private-2 = module.vpc.private_subnet_ids["private-2"]
  }

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = each.value
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.test_profile.name

  connection {
    type                = "ssh"
    user                = "ubuntu"
    host                = self.private_ip
    private_key         = file("/Users/sonu/Downloads/Marutikey.pem")

    bastion_host        = aws_instance.public.public_ip
    bastion_user        = "ubuntu"
    bastion_private_key = file("/Users/sonu/Downloads/Marutikey.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}
#Locals#

locals {
  common_ports = [22, 80, 443]
}

#########Security Group for Public EC2#########


resource "aws_security_group" "public_ec2_sg" {
  name        = "${var.env}-public-ec2-sg"
  description = "Security Group for Public EC2"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = local.common_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-public-ec2-sg"
  }
}

resource "aws_security_group" "private_ec2_sg" {
  name        = "${var.env}-private-ec2-sg"
  description = "Security Group for Private EC2"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = local.common_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-private-ec2-sg"
  }
}