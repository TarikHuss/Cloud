#!/bin/bash

echo "Brisanje aplikacije..."

if [ ! -d "flask-vue-crud" ]; then
    echo "Aplikacija nije pronađena."
    exit 0
fi

cd flask-vue-crud

echo "Zaustavljanje i brisanje kontejnera..."
docker-compose down -v

echo "Brisanje Docker slika..."
docker-compose down --rmi all

echo "Brisanje volumena..."
docker volume rm postgres_data 2>/dev/null || true

echo "Brisanje Docker mreže..."
docker network rm app-network 2>/dev/null || true

cd ..

echo "Brisanje Docker konfiguracije je završeno."
echo "Svi kontejneri, slike, volumeni i mreže su uklonjeni."
