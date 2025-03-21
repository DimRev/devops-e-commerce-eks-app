output "firehose_delivery_stream_arn" {
  description = "ARN of the Firehose delivery stream."
  value       = aws_kinesis_firehose_delivery_stream.this.arn
}

output "kinesis_stream_arn" {
  description = "ARN of the Kinesis stream."
  value       = aws_kinesis_stream.this.arn
}

output "kinesis_stream_name" {
  description = "Name of the Kinesis stream."
  value       = aws_kinesis_stream.this.name
}
