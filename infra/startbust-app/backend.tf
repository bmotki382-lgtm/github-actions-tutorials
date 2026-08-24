terraform {
  backend "s3" {
    bucket  = "terraform-motkiapplication"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}