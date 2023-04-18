terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile    = "ada"
  region     = "us-east-1"
}

# 1. Create vpc
resource "aws_vpc" "rds-vpc" {
cidr_block = "172.16.1.0/25"

  tags = {
    Name = "dev"
  }
}

# Cria uma VPC, um tipo de rede privada dentro da AWS.
resource "aws_vpc" "dev-vpc" {
  cidr_block = "172.16.1.0/25"

  tags = {
    Name = "VPC 1 - DE-OP-009"
  }
}

# Cria uma subnet que pertence àquela rede privada
resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "172.16.1.48/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet 1 - DE-OP-009"
  }
}

# Cria outra subnet que pertence àquela rede privada
resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "172.16.1.64/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subnet 2 - DE-OP-009"
  }
}

resource "aws_db_subnet_group" "db-subnet" {
    name = "db_subnet_group"
    subnet_ids = [aws_subnet.private-subnet1.id, aws_subnet.private-subnet2.id]
}


# Cria um grupo de segurança contendo regras de entrada e saída de rede. 
# Idealmente, apenas abra o que for necessário e preciso.
resource "aws_security_group" "allow_db" {
  name        = "Permite conexão do RDS"
  description = "Grupo de segurança para permitir conexão ao db"
  vpc_id      = aws_vpc.rds-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DE-OP-009"
  }
}

# Cria uma instância de RDS
resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "username"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [aws_security_group.allow_db.id]
}

output "rds_connection_string" {
  value = aws_db_instance.mysql.endpoint
} 
