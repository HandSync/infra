# ===================================================================
# S3 Buckets Públicos - Terraform
# Compatível com configuração "BucketOwnerEnforced"
# ===================================================================

# ===================================================================
# Buckets
# ===================================================================

resource "aws_s3_bucket" "raw" {
  bucket = "handsync-raw"
}

resource "aws_s3_bucket" "trusted" {
  bucket = "handsync-trusted"
}

resource "aws_s3_bucket" "curated" {
  bucket = "handsync-curated"
}

# ===================================================================
# Definir propriedade do bucket (desativa ACLs e aplica modo seguro)
# ===================================================================

resource "aws_s3_bucket_ownership_controls" "raw" {
  bucket = aws_s3_bucket.raw.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_ownership_controls" "trusted" {
  bucket = aws_s3_bucket.trusted.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_ownership_controls" "curated" {
  bucket = aws_s3_bucket.curated.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# ===================================================================
# Desabilitar bloqueio de acesso público (permitir público)
# ===================================================================

resource "aws_s3_bucket_public_access_block" "raw" {
  bucket                  = aws_s3_bucket.raw.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "trusted" {
  bucket                  = aws_s3_bucket.trusted.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "curated" {
  bucket                  = aws_s3_bucket.curated.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ===================================================================
# Políticas de bucket para leitura pública
# ===================================================================

data "aws_iam_policy_document" "raw_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.raw.arn}/*"]
  }
}

data "aws_iam_policy_document" "trusted_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.trusted.arn}/*"]
  }
}

data "aws_iam_policy_document" "curated_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.curated.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "raw" {
  bucket = aws_s3_bucket.raw.id
  policy = data.aws_iam_policy_document.raw_policy.json
}

resource "aws_s3_bucket_policy" "trusted" {
  bucket = aws_s3_bucket.trusted.id
  policy = data.aws_iam_policy_document.trusted_policy.json
}

resource "aws_s3_bucket_policy" "curated" {
  bucket = aws_s3_bucket.curated.id
  policy = data.aws_iam_policy_document.curated_policy.json
}
