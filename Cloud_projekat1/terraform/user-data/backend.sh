#!/bin/bash
set -e

# Update sistem
yum update -y

# Instalacija Docker-a
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Dodavanje ec2-user u docker grupu
usermod -a -G docker ec2-user

# Instalacija Git-a i PostgreSQL klijenta
yum install git postgresql -y

# Kloniranje repozitorija
cd /home/ec2-user
git clone ${github_repo} app
cd app/Cloud_projekat1

# Čekanje da RDS bude spreman
echo "Waiting for database to be ready..."
for i in {1..30}; do
  if pg_isready -h ${db_host} -p ${db_port} -U ${db_username}; then
    echo "Database is ready!"
    break
  fi
  echo "Waiting for database... ($i/30)"
  sleep 10
done

# Build backend kontejnera
cd server
docker build -t backend .

# Pokretanje backend kontejnera sa RDS kredencijalima
docker run -d \
  --name backend \
  --restart unless-stopped \
  -p 5000:5000 \
  -e DATABASE_URL="postgresql://${db_username}:${db_password}@${db_host}:${db_port}/${db_name}" \
  -e FLASK_ENV=production \
  -e FLASK_APP=app.py \
  backend

# Čekanje da backend bude spreman
sleep 15

# Inicijalizacija baze podataka kroz Flask aplikaciju
docker exec backend python -c "
from app import db, app
with app.app_context():
    db.create_all()
    print('Database tables created!')
"

# Log fajl za debugging
echo "Backend deployment completed at $(date)" >> /var/log/backend-deployment.log
