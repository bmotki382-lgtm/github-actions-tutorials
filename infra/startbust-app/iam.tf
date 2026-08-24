resource "aws_sqs_queue_policy" "s3_policy" {
  queue_url = aws_sqs_queue.s3_queue.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowS3SendMessage"
        Effect = "Allow"

        Principal = {
          Service = "s3.amazonaws.com"
        }

        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.s3_queue.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_s3_bucket.bucket["sonubucket"].arn
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "test_policy" {
  name        = "${var.env}-test-policy"
  description = "Policy for EC2"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.bucket["sonubucket"].arn,
          "${aws_s3_bucket.bucket["sonubucket"].arn}/*",
          aws_s3_bucket.bucket["jitubucket"].arn,
          "${aws_s3_bucket.bucket["jitubucket"].arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "${var.env}-test-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test_policy.arn
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.env}-test-instance-profile"
  role = aws_iam_role.test_role.name
}


resource "aws_iam_policy" "lambda_sqs_policy" {
  name = "${var.env}-lambda-sqs-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]

      Resource = aws_sqs_queue.s3_queue.arn
    }]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_sqs_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}


resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "vpc_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_iam_role" "lambda_role" {
  name = "${var.env}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "lambda_secret_policy" {

  name = "${var.env}-lambda-secret-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = "arn:aws:secretsmanager:ap-south-1:151170150914:secret:dbseceret-5TyDsr"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_rds_role" {
  name = "lambda-rds-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_rds_read_write" {
  name = "lambda-rds-read-write"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"

      Action = [
        "rds:DescribeDBInstances",
        "rds:DescribeDBClusters",
        "rds:DescribeDBSnapshots",
        "rds:ListTagsForResource",
        "rds:ModifyDBInstance"
      ]

      Resource =  aws_db_instance.mysql["mysql-db-1"].arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_rds_policy" {
  role       = aws_iam_role.lambda_rds_role.name
  policy_arn = aws_iam_policy.lambda_rds_read_write.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}