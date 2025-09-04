# Buckets S3
resource "aws_s3_bucket" "raw" {
  bucket = "handsync-raw"
}

resource "aws_s3_bucket" "trusted" {
  bucket = "handsync-trusted"
}

resource "aws_s3_bucket" "curated" {
  bucket = "handsync-curated"
}