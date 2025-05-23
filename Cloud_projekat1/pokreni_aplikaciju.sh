#!/bin/bash

echo "Pokretanje aplikacije..."

if [ ! -d "flask-vue-crud" ]; then
    echo "Aplikacija nije pripremljena. Prvo pokrenite './pripremi_aplikaciju.sh'."
    exit 1
fi

cd flask-vue-crud

echo "Pokretanje kontejnera..."
docker-compose up -d

echo "Provjera statusа kontejnera..."
sleep 5
docker-compose ps

echo "============================================="
echo "Aplikacija je uspješno pokrenuta!"
echo "Možete joj pristupiti na: http://localhost:8080"
echo "API je dostupan na: http://localhost:5001/books"
echo "============================================="
