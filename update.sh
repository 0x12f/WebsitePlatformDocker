#!/bin/bash

# shutdown docker
docker-compose down

# update current repo
git pull

# update submodule
submodule update --checkout --remote --force

# install all php composer
./composer install

# make writable folders
chmod 0777 $PWD/var -R
chmod 0777 $PWD/engine/public/uploads -R

# power on docker
docker-compose up -d

# update database schemes
docker-compose run php vendor/bin/doctrine orm:schema-tool:update --force

# make writable db file
chmod 0777 $PWD/var/database.sqlite

# save current version
cd engine && git describe --exact-match --tags $(git log -n1 --pretty='%h') > ./var/version.txt
