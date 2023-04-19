variable "subnet_cidr_block" {
    type = list
    default = ["172.16.1.48/28", "172.16.1.64/28", "172.16.1.80/28"]
    description = "CIDR block as subnets"
}

variable "subnet_availability_zone" {
  type = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "AZ para as subnets"
}

variable "subnet_count" {
  type = number
  default = 3
  description = "Número de subnets a serem criadas"
}

variable "producao" {
  type = bool
  default = false
  description = "Variável que indica se as configs são de produção ou não."

}
