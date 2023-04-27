resource "aws_s3_bucket" "b" {
  bucket = "de-op-009-bucket-diego-lambda-v2"
  force_destroy = true

  tags = {
    Name  = "Meu bucket de testes com lambda"
    Turma = "DE-OP-009-983"
  }
}
