output "rds_connection_string" {
  value = aws_db_instance.mysql.endpoint
}

output "username" {
  value = aws_db_instance.mysql.username
}

output "password" {
  sensitive = true
  # posso usar um comando do terraform para ler o valor terraform output -raw password
  value = aws_db_instance.mysql.password 
}
