#!/bin/bash

docker-compose down
git pull
git submodule update --merge --remote
./composer install
chmod 0777 $PWD/var -R
chmod 0777 $PWD/engine/public/uploads -R
docker-compose up -d
docker-compose run php vendor/bin/doctrine orm:schema-tool:update --force
chmod 0777 $PWD/var/database.sqlite
