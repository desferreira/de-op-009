
# Cria um documento para política do "lambda ser um lambda", assumir uma role.
# Pode ser utilizado também um objeto do tipo aws_s3_bucket_policy, como temos no 2 - s3 com website. 
# São duas formas de "fazer a mesma coisa". 
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Crio uma role para o lambda. 
# Lembrando: uma role é um conjunto de permissões.
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_para_o_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Crio uma permissão para o lambda poder criar log streams 
# e enviar logs para o cloudwatch
resource "aws_iam_policy" "function_logging_policy" {
  name = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "create_network_interface" {
  name = "create-network-interface"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Aqui eu adiciono mais uma policy à role do lambda. 
# Posso adicionar quantas forem necessárias
resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

# Aqui eu adiciono mais uma policy à role do lambda. 
# Posso adicionar quantas forem necessárias
resource "aws_iam_role_policy_attachment" "function_network_interface" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.create_network_interface.arn
}

data "archive_file" "lambda" {
  type       = "zip"
  source_dir = "src/"
  # source_file = "postgres.py" # Para pastas, usar: source_dir 
  # source_file = "${path.module}/lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

# Cria um grupo de segurança contendo regras de entrada e saída de rede. 
# Idealmente, apenas abra o que for necessário e preciso.
resource "aws_security_group" "allow_access_to_rds" {
  name        = "permite_conexao_lambda_rds"
  description = "Grupo de seguranca para permitir conexao ao rds"
  vpc_id      = aws_vpc.dev-vpc.id

  egress {
    description = "Porta de conexao ao Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.dev-vpc.cidr_block] # aws_vpc.dev-vpc.cidr_blocks
  }

  tags = {
    Name = "DE-OP-009"
  }

}

resource "aws_lambda_function" "test_lambda" {
  function_name = var.nome_lambda
  filename      = "lambda_function_payload.zip"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "postgres.lambda_metodo"
  vpc_config {
    subnet_ids         = [aws_subnet.private-subnet[0].id]
    security_group_ids = [aws_security_group.allow_access_to_rds.id]
  }

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = var.versao_python

  depends_on = [
    aws_subnet.private-subnet[0],
    aws_iam_role.iam_for_lambda,
    aws_iam_role_policy_attachment.function_logging_policy_attachment,
    aws_iam_role_policy_attachment.function_network_interface,
    aws_db_instance.mysql,
    aws_s3_bucket.b
  ]

  # Coloco nos environments tudo que eu quiser que minha função lambda tenha acesso em 
  # tempo de execução. Por exemplo: URL de banco de dados, usuário, senha...
  environment {
    variables = {
      DB_URL  = aws_db_instance.mysql.address
      DB_PORT = aws_db_instance.mysql.port
      DB_USER = aws_db_instance.mysql.username
      DB_PASS = aws_db_instance.mysql.password
    }
  }
}

# Adiciono permissões ao meu bucket s3 para invocar (fazer trigger) à minha função lambda.
resource "aws_lambda_permission" "invoke_function" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.b.id}"
  depends_on = [
    aws_s3_bucket.b,
    aws_lambda_function.test_lambda
  ]
}

# Adiciono a funcionalidade do bucket s3 enviar notificações à minha função lambda.
# Os eventos que serão notificados são: Objetos criados (upload) e objetos removidos (delete).
resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = aws_s3_bucket.b.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = var.eventos_lambda_s3
  }

  # O depends_on aqui garante que esse recurso "aws_s3_bucket_notification" 
  # só será criado APÓS  "aws_lambda_permission" "invoke_function", que é um "pré requisito"
  depends_on = [aws_s3_bucket.b, aws_lambda_function.test_lambda]
}

# Aqui eu crio um log group no cloudwatch... um log group pode ser considerado uma "pastinha" para armazenar todos os logs de uma determinada função
resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = var.retencao_logs

  lifecycle {
    prevent_destroy = false
  }
}
