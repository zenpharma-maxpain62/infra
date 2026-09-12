terraform {
  backend "s3" {
    bucket       = "testbkt17062025"  # Replace with your S3 bucket name
    key          = "zenpharma/envs/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true   # S3 native locking (Terraform >= 1.11)
  }
}