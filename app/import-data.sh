#!/bin/bash

export DB_URI="172.24.0.2"
export DB_PORT="27017"
export DB_NAME="deportes"
export data_uri="https://fx-nunchee-assets.s3.amazonaws.com/data/sports.xml"

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

mongo_check(){
    mongo --version
    if [ $? -eq 0 ]; then
        echo MongoDB is installed.
    else
    echo Installing MongoDB . . .
    apt update; sudo apt install -y mongodb-org
    systemctl start mongod
    systemctl daemon-reload
    systemctl status mongod
    systemctl enable mongod
fi
}

# mongo_check
# sleep 5
# echo mongo check SUCCESS
wget $data_uri
sleep 5
# echo get data from uri SUCCESS
# install_dependencies
sleep 5
# echo install dependencies SUCCESS
xml_to_json
sleep 5
# echo processing data SUCCESS
import_data
sleep 5
# echo import data SUCCESS