

resource "aws_s3_bucket" "s3_bucket" {
   bucket = "${var.project}-${var.environment}-new"
}

resource "aws_s3_bucket_ownership_controls" "controls" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.controls]

  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_notification" "s3_notification" {
  bucket = aws_s3_bucket.s3_bucket.id

  queue {
    events    = ["s3:ObjectCreated:*"]
    queue_arn = aws_sqs_queue.s3-notifications-sqs.arn
    filter_prefix = ""
  }
}

resource "aws_sqs_queue" "s3-notifications-sqs" {

  name = "${var.project}-${var.environment}-new"
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": "arn:aws:sqs:*:*:${var.project}-${var.environment}-new",
        "Condition": {
          "ArnEquals": {
           "aws:SourceArn":     
              "${aws_s3_bucket.s3_bucket.arn}" 
           }
        }
      }
    ]
  }
  POLICY
}