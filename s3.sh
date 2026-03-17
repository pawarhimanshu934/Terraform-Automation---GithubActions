# Create bucket
aws s3 mb s3://s3-for-github-actions-terraform-automation --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket s3-for-github-actions-terraform-automation \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket s3-for-github-actions-terraform-automation \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Block public access
aws s3api put-public-access-block \
  --bucket s3-for-github-actions-terraform-automation \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true


# # Create an S3 bucket with the specified name and tagss
# resource "aws_s3_bucket" "my_bucket" {
#   bucket = var.bucket_name

#   tags = {
#     Name        = "MyBucket"
#     Environment = var.environment
#   }
# }

# # Set the bucket ownership controls to "BucketOwnerPreferred"
# resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership" {
#   bucket = aws_s3_bucket.my_bucket.id

#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }

# }

# # Set the ACL to private for the S3 bucket
# resource "aws_s3_bucket_acl" "my_bucket_acl" {
#   depends_on = [ aws_s3_bucket_ownership_controls.my_bucket_ownership ]
#   bucket = aws_s3_bucket.my_bucket.id
#   acl    = "private"
# }

# # Block public access to the S3 bucket
# resource "aws_s3_bucket_public_access_block" "my_bucket_public_access" {
#   bucket = aws_s3_bucket.my_bucket.id

#   block_public_acls       = true
#   ignore_public_acls      = true
#   block_public_policy     = true
#   restrict_public_buckets = true
# }

# # Enable versioning for the S3 bucket
# resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
#   bucket = aws_s3_bucket.my_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # Create a KMS key for S3 bucket encryption
# resource "aws_kms_key" "my_kms_key" {
#   description = "KMS key for S3 bucket encryption"
#   deletion_window_in_days = 10
# }

# # Enable server-side encryption using the KMS key for the S3 bucket
# resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_encryption" {
#   bucket = aws_s3_bucket.my_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "aws:kms"
#       kms_master_key_id = aws_kms_key.my_kms_key.arn
#     }
#   }
# }