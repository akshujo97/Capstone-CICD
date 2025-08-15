output "app_ip" { value = aws_instance.app.public_ip }
output "db_host" { value = aws_db_instance.pg.address }
output "db_port" { value = aws_db_instance.pg.port }
