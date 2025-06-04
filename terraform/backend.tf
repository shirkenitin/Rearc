terraform {
  backend "s3" {
    bucket = "dev-rearc-terraform"
    key    = "rearc/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "terraform-locks"   # Optional but recommended
    encrypt = true
  }
}
