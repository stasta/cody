resource "aws_s3_bucket" "tf-remote-state-bucket" {
  bucket = "${var.account_alias}-terraform-state"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = "${aws_s3_bucket.tf-remote-state-bucket.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
