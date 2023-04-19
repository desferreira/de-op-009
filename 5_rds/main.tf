terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "ada"
  region  = "us-east-1"
}

# Cria uma VPC, um tipo de rede privada dentro da AWS.
resource "aws_vpc" "dev-vpc" {
  cidr_block = "172.16.1.0/25" # o /25 indica a quantidade de IPs disponíveis para máquinas na rede

  tags = {
    Name = "VPC 1 - DE-OP-009"
  }
}

# Cria uma subnet que pertence àquela rede privada 
resource "aws_subnet" "private-subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_cidr_block[count.index] # "172.16.1.0/25" 172.16.1.48 até 172.16.1.64 
  availability_zone = var.subnet_availability_zone[count.index]

  tags = {
    Name = "Subnet ${count.index + 1} - DE-OP-009"
  }
}

resource "aws_db_subnet_group" "db-subnet" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
}

# Cria um grupo de segurança contendo regras de entrada e saída de rede. 
# Idealmente, apenas abra o que for necessário e preciso.
resource "aws_security_group" "allow_db" {
  name        = "permite_conexao_rds"
  description = "Grupo de seguranca para permitir conexao ao db"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # aws_vpc.dev-vpc.cidr_blocks
  }

  egress {
    description = "HTTPS"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # aws_vpc.dev-vpc.cidr_blocks
  }

  tags = {
    Name = "DE-OP-009"
  }
}

# Cria uma instância de RDS
resource "aws_db_instance" "mysql" {
  allocated_storage = 10
  db_name           = "mydb"
  engine            = "postgres"
  engine_version    = "12.9"
  instance_class    = "db.t3.micro"
  username          = "username" # Nome do usuário "master"
  password          = "password" # Senha do usuário master
  port              = 5432
  # Parâmetro que indica se o DB vai ser acessível publicamente ou não.
  # Se quiser adicionar isso, preciso de um internet gateway na minha subnet. Em outras palavras, preciso permitir acesso "de fora" da aws.
  # publicly_accessible    = true

  # Parâmetro que indica se queremos ter um cluster RDS que seja multi az. 
  # Lembrando, paga-se a mais por isso, mas para ambientes produtivos é essencial.
  # multi_az               = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [aws_security_group.allow_db.id]
}

output "rds_connection_string" {
  value = aws_db_instance.mysql.endpoint
}
