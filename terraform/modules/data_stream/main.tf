#############################
# Kinesis Stream Resource ("this")
#############################
resource "aws_kinesis_stream" "this" {
  name             = "${var.environment}-${var.app_name}-${var.name_prefix}-kinesis-stream"
  retention_period = var.retention_period

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-kinesis-stream"
  }
}

#############################
# Firehose Delivery Stream Resource ("this")
#############################
resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = "${var.environment}-${var.app_name}-${var.name_prefix}-firehose-delivery-stream"
  destination = "extended_s3"


  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = var.s3_bucket_arn
    prefix     = "${var.bucker_path_prefix}/"

    buffering_size     = var.buffering_size
    buffering_interval = var.buffering_interval

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_log_stream.name
    }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.this.arn
    role_arn           = aws_iam_role.firehose.arn
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-firehose-delivery-stream"
  }
}
