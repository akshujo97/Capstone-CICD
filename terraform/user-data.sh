#!/bin/bash
set -euo pipefail

DB_HOST="${db_host}"
DB_PORT="${db_port}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
DB_NAME="${db_name}"
BACKEND_IMAGE="${backend_image}"
FRONTEND_IMAGE="${frontend_image}"

# Install Docker (Amazon Linux 2023 prefers dnf)
if command -v dnf >/dev/null 2>&1; then
  dnf -y update
  dnf -y install docker
else
  yum -y update
  yum -y install docker || true
fi
systemctl enable --now docker
usermod -aG docker ec2-user || true

# App network for service discovery
docker network create resqpost-net || true

# Backend (alias = backend)
docker pull "$${BACKEND_IMAGE}" || true
docker rm -f resqpost-backend 2>/dev/null || true
docker run -d --name resqpost-backend \
  --network resqpost-net --network-alias backend \
  -p 5000:5000 \
  -e DATABASE_URL="postgresql+psycopg2://$${DB_USER}:$${DB_PASSWORD}@$${DB_HOST}:$${DB_PORT}/$${DB_NAME}" \
  -e FLASK_ENV=production \
  "$${BACKEND_IMAGE}"

# Frontend (talks to http://backend:5000)
docker pull "$${FRONTEND_IMAGE}" || true
docker rm -f resqpost-frontend 2>/dev/null || true
docker run -d --name resqpost-frontend \
  --network resqpost-net \
  -p 80:80 \
  "$${FRONTEND_IMAGE}"
