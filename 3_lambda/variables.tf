# Aqui eu adiciono todas as variáveis que serão importantes para a criação e configuração
# da minha infraestrutura. Não necessariamente todas precisam estar no ambiente da lambda.

variable "eventos_lambda_s3" {
  type = list
  default = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  description = "Variável contendo uma lista de eventos a serem notificados pelo bucket S3."
}

variable "retencao_logs" {
  type = number
  default = 1
  description = "Número de dias de retenção dos logs."
}

variable "versao_python" {
  type = string
  default = "python3.9"
  description = "Versão do python para executar a função."
}

variable "nome_lambda" {
  type = string
  default = "lambda05"
  description = "Nome da função lambda da funcionalidade X."
}
