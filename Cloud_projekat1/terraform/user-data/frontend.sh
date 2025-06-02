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
cd app/Cloud_projekat1/flask-vue-crud/client

# Automatski zameni localhost:5001 sa ALB URL-om
echo "Replacing localhost URLs with ALB URL: ${backend_url}" >> /var/log/frontend-deployment.log
find src/ -name "*.vue" -exec sed -i "s|http://localhost:5001|${backend_url}|g" {} \;
find src/ -name "*.js" -exec sed -i "s|http://localhost:5001|${backend_url}|g" {} \;

# Proveri da li je zamena uspešna
echo "URLs after replacement:" >> /var/log/frontend-deployment.log
grep -r "http://" src/ >> /var/log/frontend-deployment.log

# Build i pokretanje frontend kontejnera
docker build -t frontend .

# Pokretanje frontend kontejnera
docker run -d \
  --name frontend \
  --restart unless-stopped \
  -p 8080:5173 \
  frontend

# Čekaj da se kontejner pokrene
sleep 10

# Proveri status
docker ps >> /var/log/frontend-deployment.log

# Log fajl za debugging
echo "Frontend deployment completed at $(date)" >> /var/log/frontend-deployment.log
