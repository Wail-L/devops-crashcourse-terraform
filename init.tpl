#!/bin/bash

apt-get install git
apt-get install docker-compose
git clone https://github.com/maur1th/simple-php-app
cd simple-php-app/
docker-compose up -d
echo "CONSUL_ADDRESS = ${consul_address}" > /tmp/iplista
