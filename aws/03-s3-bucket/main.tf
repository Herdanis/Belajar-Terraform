provider "aws" {
  region = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_s3_bucket" "finance-bucket" {
  bucket = "coba-bikin-s3"
  tags = {
    description = "test S3"
  }
}

resource "aws_s3_object" "upload-txt" {
  content = "pets.txt"
  key = "pets.txt"
  bucket = aws_s3_bucket.finance-bucket.id
}

resource "aws_iam_group" "finance-group" {
  name = "finance-team"
}

resource "aws_s3_bucket_policy" "finance-policy" {
  bucket = aws_s3_bucket.finance-bucket.id
  depends_on = [ aws_iam_group.finance-group ]
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.finance-bucket.id}/*",
            "Principal": {
              "AWS": [
                "${aws_iam_group.finance-group.arn}"
              ]
            }
        }
    ]
}
EOF
}
