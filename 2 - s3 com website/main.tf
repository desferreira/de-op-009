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
    Name        = "Meu bucket com site"
    Turma = "DE-OP-009-983"
  }
}

resource "aws_s3_bucket_policy" "website_access" {
  bucket = aws_s3_bucket.b.id
  policy = <<POLICY
          {
            "Version": "2012-10-17",
            "Statement": [
              {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${aws_s3_bucket.b.bucket}/*"
              }
            ]
          }
          POLICY
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.b.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

# aws s3 cp FILE s3://BUCKET_NAME --profile ada
