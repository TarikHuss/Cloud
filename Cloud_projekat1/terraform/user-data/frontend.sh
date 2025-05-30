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

# Instalacija Git-a
yum install git -y

# Kloniranje repozitorija
cd /home/ec2-user
git clone ${github_repo} app
cd app/Cloud_projekat1/client

# Proverite da li postoji package.json
if [ ! -f "package.json" ]; then
    echo "ERROR: package.json not found!" >> /var/log/frontend-deployment.log
    ls -la >> /var/log/frontend-deployment.log
    exit 1
fi

# Build i pokretanje frontend kontejnera
docker build -t frontend .

# Pokretanje frontend kontejnera
docker run -d \
  --name frontend \
  --restart unless-stopped \
  -p 8080:5173 \
  -e VUE_APP_API_URL=${backend_url} \
  -e NODE_ENV=production \
  frontend

# Log fajl za debugging
echo "Frontend deployment completed at $(date)" >> /var/log/frontend-deployment.log
docker ps >> /var/log/frontend-deployment.log
