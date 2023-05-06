terraform {
  backend "s3" {
    bucket = "yasser-terraform-state"
    key    = "terraform/backend-exercise"
    region = "eu-west-1"

  }
}