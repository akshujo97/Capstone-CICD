variable "aws_region" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "resqpost"
}

variable "key_name" {
  type    = string
  default = null
}

variable "backend_image" {
  type = string
}

variable "frontend_image" {
  type = string
}
