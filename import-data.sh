#!/bin/bash

# export DB_URI=""
export DB_PORT="27017"
export DB_NAME="deportes"
export data_uri="https://fx-nunchee-assets.s3.amazonaws.com/data/sports.xml"

copying_db_ip(){
    export DB_URI="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mongodb)"
}

install_dependencies(){
    apt update
    apt install -y pip jq 
    pip install jq yq xq
}

xml_to_json(){
    cat sports.xml | xq '.plantelEquipo.equipo[]' > equipos.json
    cat sports.xml | xq '.plantelEquipo.equipo[].jugadores.jugador[]' > jugadores.json
}

import_data(){
    mongoimport mongodb://$DB_URI:$DB_PORT/$DB_NAME equipos.json
    mongoimport mongodb://$DB_URI:$DB_PORT/$DB_NAME jugadores.json
}

echo "Copying Database IP address ..."
sleep 5
if [ "$(docker ps | grep mongodb)" ]; then
    copying_db_ip
else { echo "Database isn't running." ; exit 1 ;}
fi
sleep 5
echo "Downloading data seed ..."
if [ ! -f "sports.xml" ]; then
    wget $data_uri
fi
sleep 5
echo "Processing data ..."
if [ ! -f "equipos.json" ] && [ ! -f "jugadores.json" ]; then
    xml_to_json
fi
sleep 5
echo "Importing collections to database ..."
import_data
sleep 5
