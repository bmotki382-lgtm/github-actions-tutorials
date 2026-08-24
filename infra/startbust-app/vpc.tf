module "vpc" {

  source = "../starbust-module/VPC"

  region   = var.region
  vpc_name = "${var.env}-vpc"
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}


resource "aws_vpc_endpoint" "s3" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${var.region}.s3"

  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    module.vpc.private_route_table_id
  ]
}


resource "aws_security_group" "rds_endpoint_sg" {

  name        = "${var.env}-rds-endpoint-sg"
  description = "Security group for RDS interface endpoint"
  vpc_id      = module.vpc.vpc_id


  ingress {

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    security_groups = [
      aws_security_group.private_ec2_sg.id
    ]
  }


  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}


resource "aws_vpc_endpoint" "rds" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${var.region}.rds"

  vpc_endpoint_type = "Interface"

  subnet_ids = [
    module.vpc.private_subnet_ids["private-1"],
    module.vpc.private_subnet_ids["private-2"]
  ]

  security_group_ids = [
    aws_security_group.rds_endpoint_sg.id
  ]

  private_dns_enabled = true
}