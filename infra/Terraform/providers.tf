terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
  backend "s3" {
    bucket         = "siadevops-bucket"
    key            = "workspace.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "siadevops-table"
  }
}
provider "aws" {
  region = "ap-south-2"
}