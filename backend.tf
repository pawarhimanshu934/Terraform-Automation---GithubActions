terraform {
  backend "s3" {
    bucket = "s3-for-github-actions-terraform-automation"
    key = "terraform/state/main/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true

  }
}


#var.bucket_name and var.region are normal Terraform variables, they won't work here.
#The backend block is evaluated before Terraform loads variables, so backend configuration cannot use input variables. You need to Hardcode values