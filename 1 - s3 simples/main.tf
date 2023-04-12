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
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}

resource "aws_s3_bucket" "b" {
  bucket = "de-op-009-bucket-diego"

  tags = {
    Name        = "Meu bucket de testes inicial"
    Turma = "DE-OP-009-983"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
