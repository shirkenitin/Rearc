terraform {
  backend "s3" {
    bucket = "dev-rearc-terraform-state"
    key    = "rearc/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "terraform-locks"   # Optional but recommended
    encrypt = true
  }
}
