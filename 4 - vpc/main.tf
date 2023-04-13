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
