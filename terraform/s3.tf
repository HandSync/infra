# ===================================================================
# S3 Buckets - versão mínima, apenas para referência na Lambda
# ===================================================================

resource "aws_s3_bucket" "raw" {
  bucket = "handsync-raw-hs"
}

resource "aws_s3_bucket" "trusted" {
  bucket = "handsync-trusted-hs"
}
