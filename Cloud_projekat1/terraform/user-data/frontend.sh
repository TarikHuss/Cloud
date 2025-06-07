#!/bin/bash
set -e

# Update sistem
yum update -y

# Instalacija Docker-a
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Instalacija Git-a
yum install git -y

# Kloniranje repozitorija
cd /home/ec2-user
git clone ${github_repo} app
cd app/Cloud_projekat1/flask-vue-crud/client

# Zameni localhost:5001 sa ALB URL
echo "Replacing localhost URLs with ALB URL: ${backend_url}" >> /var/log/frontend-deployment.log
find src/ -name "*.vue" -exec sed -i "s|http://localhost:5001|${backend_url}|g" {} \;

# Build sa standardnim Dockerfile
echo "Building Docker image..." >> /var/log/frontend-deployment.log
docker build -t frontend . >> /var/log/frontend-deployment.log 2>&1

# Pokreni kontejner
echo "Starting container..." >> /var/log/frontend-deployment.log
docker run -d \
  --name frontend \
  --restart unless-stopped \
  -p 8080:8080 \
  frontend >> /var/log/frontend-deployment.log 2>&1

echo "Frontend deployment completed at $(date)" >> /var/log/frontend-deployment.log
docker ps >> /var/log/frontend-deployment.log
