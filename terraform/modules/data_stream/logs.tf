#############################
# CloudWatch Log Group for Firehose
#############################
resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name = "/aws/kinesisfirehose/${var.environment}-${var.app_name}-${var.name_prefix}-delivery"

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-firehose-delivery"
  }
}

#############################
# CloudWatch Log Stream for Firehose
#############################
resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "${var.environment}-${var.app_name}-${var.name_prefix}-stream"
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
}
