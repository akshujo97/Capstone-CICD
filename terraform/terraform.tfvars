aws_region       = "us-east-1"
allowed_ssh_cidr = "174.116.34.102/32"

db_user     = "postgres"
db_password = "ChangeMe123!" # change if you want
db_name     = "resqpost"

backend_image  = "docker.io/twinklem97/resqpost-backend:latest"
frontend_image = "docker.io/twinklem97/resqpost-frontend:latest"

# optional: uncomment if you want SSH and have a key pair in AWS
key_name = "resqpost-key"
