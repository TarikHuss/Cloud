#!/bin/bash

echo "Zaustavljanje aplikacije..."

if [ ! -d "flask-vue-crud" ]; then
    echo "Aplikacija nije pripremljena. Prvo pokrenite './pripremi_aplikaciju.sh'."
    exit 1
fi

cd flask-vue-crud

echo "Zaustavljanje kontejnera..."
docker-compose stop

echo "Aplikacija je zaustavljena. Podaci su i dalje sačuvani."
echo "Za ponovno pokretanje koristite './pokreni_aplikaciju.sh'."
