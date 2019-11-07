#!/bin/bash

# shutdown docker
docker-compose down

# hard reset all changes
git reset --hard

# update current repo
git pull

# update engine
cd engine && git reset --hard && git pull -f && cd ..

# install all php composer
./composer install

# make cmod files and folders
chmod 0777 install.sh update.sh
chmod 0777 $PWD/var -R
chmod 0777 $PWD/engine/public/uploads -R

# power on docker
docker-compose up -d

# update database schemes
docker-compose run php vendor/bin/doctrine orm:schema-tool:update --force

# make writable db file
chmod 0777 $PWD/var/database.sqlite

# save current version
cd engine && git describe --exact-match --tags $(git log -n1 --pretty='%h') > ../var/version.txt
