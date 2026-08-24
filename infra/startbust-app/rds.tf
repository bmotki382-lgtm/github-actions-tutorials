data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.db_secret_arn
}


locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_security_group" "rds_sg" {

  name        = "${var.env}-rds-sg"
  description = "Security Group for RDS"
  vpc_id      = module.vpc.vpc_id


  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [
      aws_security_group.private_ec2_sg.id,
      aws_security_group.lambda_sg.id
    ]
  }
}


resource "aws_db_subnet_group" "rds_subnet_group" {

  name = "${var.env}-rds-subnet-group"

  subnet_ids = [
    module.vpc.private_subnet_ids["private-1"],
    module.vpc.private_subnet_ids["private-2"]
  ]
}


resource "aws_db_instance" "mysql" {

  for_each = var.rds_instances

  identifier = "${var.env}-${each.key}"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.db_instance_class

  allocated_storage = var.db_storage
  storage_type      = "gp3"

  db_name = var.rds_instances["mysql-db-1"].db_name
  username = "admin"
  password = local.db_secret.password


  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false
  skip_final_snapshot = true
  multi_az            = false
}


output "rds_endpoints" {

  value = {
    for name, db in aws_db_instance.mysql :
    name => db.endpoint
  }
}