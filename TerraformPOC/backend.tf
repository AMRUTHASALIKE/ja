 terraform {
  backend "s3" {
    bucket = "sneha-bucket"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}

