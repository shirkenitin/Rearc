terraform {
  backend "s3" {
    bucket = "dev-caau-terraform-state"
    key    = "rearc/terraform.tfstate"
    region = "eu-west-1"
    # dynamodb_table = "terraform-locks"   # Optional but recommended
    encrypt = true
  }
}
