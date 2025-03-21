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

data "aws_iam_openid_connect_provider" "oidc" {
  arn = var.eks_cluster_oidc_issuer_url
}

resource "aws_iam_role" "eks_kinesis_access" {
  name = "${var.environment}-${var.app_name}-${var.name_prefix}-eks-kinesis-access-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : data.aws_iam_openid_connect_provider.oidc.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub" : "system:serviceaccount:default:kinesis-access"
          }
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-eks-kinesis-access-role"
  }
}

resource "aws_iam_policy" "eks_kinesis_policy" {
  name        = "${var.environment}-${var.app_name}-${var.name_prefix}-eks-kinesis-access-policy"
  description = "Policy to allow Kinesis stream access"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:PutRecord",
          "kinesis:PutRecordBatch",
          "kinesis:DescribeStream"
        ],
        "Resource" : "${aws_kinesis_stream.this.arn}"
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-${var.app_name}-${var.name_prefix}-eks-kinesis-access-policy"
  }
}

resource "aws_iam_role_policy_attachment" "eks_kinesis_attach" {
  role       = aws_iam_role.eks_kinesis_access.name
  policy_arn = aws_iam_policy.eks_kinesis_policy.arn
}
