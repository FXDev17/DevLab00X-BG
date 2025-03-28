terraform {
  backend "s3" {
    bucket = "devlab00-logging"
    key    = "bg-terraform.tfstate"
    region = "eu-west-2"
  }
}