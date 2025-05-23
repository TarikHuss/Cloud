#!/bin/bash

echo "Priprema aplikacije..."

if ! command -v docker &> /dev/null; then
    echo "Docker nije instaliran. Molimo instalirajte Docker prije pokretanja."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose nije instaliran. Molimo instalirajte Docker Compose prije pokretanja."
    exit 1
fi

if [ ! -d "flask-vue-crud" ]; then
    echo "Kloniranje GitHub repozitorija..."
    git clone https://github.com/testdrivenio/flask-vue-crud.git
    cd flask-vue-crud
else
    echo "Repozitorij već postoji, nastavljam..."
    cd flask-vue-crud
fi

echo "Kopiranje Docker konfiguracije..."
cp ../docker-compose.yml .
mkdir -p client server
cp ../client/Dockerfile client/
cp ../server/Dockerfile server/

echo "Kreiranje Docker mreže..."
docker network create app-network 2>/dev/null || true

echo "Kreiranje volumena za bazu podataka..."
docker volume create postgres_data 2>/dev/null || true

echo "Izgradnja Docker slika..."
docker-compose build

echo "Priprema aplikacije je završena. Možete pokrenuti aplikaciju koristeći './pokreni_aplikaciju.sh'"
