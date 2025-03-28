#############################
# IAM Role for Firehose
#############################
resource "aws_iam_role" "firehose" {
  name = "${var.environment}-${var.app_name}-${var.name_prefix}-FirehoseRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "firehose.amazonaws.com" },
      Effect    = "Allow",
      Sid       = ""
    }]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-firehose-role"
  }
}

#############################
# IAM Policy for S3 Access Restricted to "log_path/" Folder
#############################
resource "aws_iam_policy" "firehose_s3" {
  name_prefix = var.iam_name_prefix
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "BucketLevelPermissions",
        Effect : "Allow",
        Action : [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ],
        Resource : var.s3_bucket_arn,
        Condition : {
          StringEquals : { "s3:prefix" : "${var.bucker_path_prefix}/" }
        }
      },
      {
        Sid : "ObjectLevelPermissions",
        Effect : "Allow",
        Action : [
          "s3:AbortMultipartUpload",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource : "${var.s3_bucket_arn}/${var.bucker_path_prefix}/*"
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-firehose-s3-policy"
  }
}

resource "aws_iam_role_policy_attachment" "firehose_s3_attach" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose_s3.arn
}

#############################
# IAM Policy for CloudWatch Logs
#############################
resource "aws_iam_policy" "firehose_cloudwatch" {
  name_prefix = var.iam_name_prefix
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Sid : "",
      Effect : "Allow",
      Action : [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource : aws_cloudwatch_log_group.firehose_log_group.arn
    }]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-firehose-cloudwatch-policy"
  }
}

resource "aws_iam_role_policy_attachment" "firehose_cloudwatch_attach" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose_cloudwatch.arn
}

#############################
# IAM Policy for Kinesis Firehose Access
#############################
resource "aws_iam_policy" "kinesis_firehose" {
  name_prefix = var.iam_name_prefix
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Sid : "",
      Effect : "Allow",
      Action : [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListShards"
      ],
      Resource : aws_kinesis_stream.this.arn
    }]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-firehose-kinesis-policy"
  }
}

resource "aws_iam_role_policy_attachment" "kinesis_firehose_attach" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.kinesis_firehose.arn
}

#############################
# IAM Policy for EKS Access
#############################

resource "aws_iam_policy" "eks_kinesis_policy" {
  name = "${var.environment}-${var.app_name}-${var.name_prefix}-eks-kinesis-access-policy"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "kinesis:PutRecord",
          "kinesis:PutRecordBatch",
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListShards"
        ],
        Resource : aws_kinesis_stream.this.arn
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-eks-kinesis-access-policy"
  }
}

data "aws_iam_role" "eks_role" {
  name = var.eks_cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "eks_kinesis_attach" {
  role       = data.aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.eks_kinesis_policy.arn
}


