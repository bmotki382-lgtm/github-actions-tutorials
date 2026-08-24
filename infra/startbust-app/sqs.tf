resource "aws_sqs_queue" "s3_queue" {

  name = "${var.env}-s3-event-queue"

}


resource "aws_lambda_event_source_mapping" "sqs_trigger" {

  event_source_arn = aws_sqs_queue.s3_queue.arn

  function_name = aws_lambda_function.s3_to_rds.arn

  batch_size = 1
  enabled    = true

}