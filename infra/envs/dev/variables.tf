variable "aws_region" { type = string }
variable "db_user" { type = string }

variable "db_password" {
  type      = string
  sensitive = true
}

variable "allowed_ssh_cidr" { type = string }
