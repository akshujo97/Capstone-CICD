module "vpc" {
  source     = "../../modules/vpc"
  name       = "resqpost-dev"
  cidr_block = "10.10.0.0/16"
  az_count   = 2
}

module "rds" {
  source      = "../../modules/rds"
  name        = "resqpost-dev"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids # demo; use private in prod
  db_name     = "resqpost"
  db_user     = var.db_user
  db_password = var.db_password
}

module "ec2" {
  source    = "../../modules/ec2_app"
  name      = "resqpost-dev-app"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]
  ssh_cidr  = var.allowed_ssh_cidr
}

output "app_ip" { value = module.ec2.public_ip }
output "db_host" { value = module.rds.endpoint }
output "db_port" { value = module.rds.port }
