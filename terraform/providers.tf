terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}
provider "aws" {
  access_key = ${{ secrets.access_key }}
  secret_key = ${{ secrets.secret_key }}
  region     = "us-east-1"
}



