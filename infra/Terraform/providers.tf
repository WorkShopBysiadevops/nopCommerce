terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.64.0"
    }
  }
  backend "s3" {
    bucket = aws_dynamodb_table.id
    key = "workspace.tfstate"
    region = "ap-south-2"
    dynamodb_table = aws_dynamodb_table.id
    depends_on = [aws_dynamodb_table,aws_s3_bucket]
  }
}
provider "aws" {
  region = "ap-south-2"
}