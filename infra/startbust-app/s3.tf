resource "aws_s3_bucket" "bucket" {

  for_each = var.s3_buckets

  bucket = "${var.env}-${each.value}"

}

resource "aws_s3_bucket_notification" "notification" {

  bucket = aws_s3_bucket.bucket["sonubucket"].id

  queue {

    queue_arn = aws_sqs_queue.s3_queue.arn
    events    = ["s3:ObjectCreated:*"]

  }

  depends_on = [
    aws_sqs_queue_policy.s3_policy
  ]
}


resource "aws_s3_bucket_lifecycle_configuration" "jitu_lifecycle" {

  bucket = aws_s3_bucket.bucket["jitubucket"].id

  rule {

    id     = "delete-after-1-day"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 1
    }
  }
}