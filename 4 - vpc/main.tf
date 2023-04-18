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

resource "aws_vpc" "dev-vpc" {
  cidr_block = "172.16.1.0/25"

  tags = {
    Name = "VPC 1 - DE-OP-009"
  }
}

resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "172.16.1.48/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet 1 - DE-OP-009"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "172.16.1.64/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subnet 2 - DE-OP-009"
  }
}
