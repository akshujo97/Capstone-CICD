resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-dbsubnet"
  subnet_ids = var.subnet_ids
  tags       = { Name = "${var.name}-dbsubnet" }
}

resource "aws_security_group" "rds" {
  name   = "${var.name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # demo only; tighten in prod
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-rds-sg" }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.name}-pg"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = true        # demo only
  username               = var.db_user
  password               = var.db_password
  db_name                = var.db_name
  skip_final_snapshot    = true
  deletion_protection    = false
  tags = { Name = "${var.name}-pg" }
}

output "endpoint" { value = aws_db_instance.this.address }
output "port"     { value = aws_db_instance.this.port }
output "sg_id"    { value = aws_security_group.rds.id }
