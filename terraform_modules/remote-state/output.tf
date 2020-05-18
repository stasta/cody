output "remote-state-bucket-name" {
  value = "${aws_s3_bucket.tf-remote-state-bucket.bucket}"
}
