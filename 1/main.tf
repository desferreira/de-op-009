terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile    = "ada" # Aqui vai o "profile" que você configurou as credenciais da AWS.
  region     = "us-east-1" 
}

resource "aws_s3_bucket" "b" {
  bucket = "de-op-009-bucket"

  tags = {
    Name        = "Meu bucket"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

output "bucket_url" {
  value = aws_s3_bucket.b.bucket_domain_name
}
