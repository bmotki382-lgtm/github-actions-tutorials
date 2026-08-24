resource "aws_lambda_function" "s3_to_rds" {

  function_name = "${var.env}-s3-to-rds"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  role    = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.13"

  timeout = 30


  vpc_config {

    subnet_ids = [
      module.vpc.private_subnet_ids["private-1"],
      module.vpc.private_subnet_ids["private-2"]
    ]

    security_group_ids = [
      aws_security_group.lambda_sg.id
    ]
  }


  environment {

    variables = {

      DB_HOST    = aws_db_instance.mysql["mysql-db-1"].address
      DB_NAME = var.rds_instances["mysql-db-1"].db_name
      DB_USER    = "admin"
      SECRET_ARN = var.db_secret_arn

    }
  }


  depends_on = [
    aws_db_instance.mysql
  ]
}



resource "aws_security_group" "lambda_sg" {

  name        = "${var.env}-lambda-sg"
  description = "Security Group for Lambda"
  vpc_id      = module.vpc.vpc_id


  dynamic "egress" {

    for_each = var.lambda_egress_rules

    content {

      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks

    }
  }
}