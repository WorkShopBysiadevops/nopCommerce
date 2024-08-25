### Creating s3 bucket
resource "aws_s3_bucket" "terraform-state"{
   bucket = "siadevops_bucket"
   tags = {
     CreatedBy = "Terraform"
     Environment = "Terraform.workspace"
     Name = "Terraform state bucket"
   }
}
### Creating dynamodb table
resource "aws_dynamodb_table" "terraform"{
   name = "siadevops_table"
   hash_key = "LockID"
   attribute {
     name = "LockID"
     type = "S"
   }
   tags = {
    CreatedBy = "Terraform"
    Environment = "Terraform.workspace"
   }
}
