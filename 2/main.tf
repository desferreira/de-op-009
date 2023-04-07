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
resource "aws_vpc" "dev-vpc" {
cidr_block = "172.16.1.0/25"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block = "172.16.1.48/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block = "172.16.1.64/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet2"
  }
}

resource "aws_db_subnet_group" "db-subnet" {
    name = "db_subnet_group"
    subnet_ids = ["${aws_subnet.private-subnet1.id}", "${aws_subnet.private-subnet2.id}"]
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "${aws_db_subnet_group.db-subnet.name}"

  
}

output "rds_connection_string" {
  value = aws_db_instance.default.address
} 