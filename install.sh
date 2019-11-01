#!/bin/bash

# init engine
git clone -q -b master https://github.com/0x12f/WebsitePlatform.git engine

# install all php composer
./composer install

# make cmod files and folders
chmod 0777 install.sh update.sh
chmod 0777 $PWD/var -R
chmod 0777 $PWD/engine/public/uploads -R

# power on docker
docker-compose up -d

# update database schemes
docker-compose run php vendor/bin/doctrine orm:schema-tool:create

# make writable db file
chmod 0777 $PWD/var/database.sqlite

# save current version
cd engine && git describe --exact-match --tags $(git log -n1 --pretty='%h') > ./var/version.txt

# create admin user
# login: admin
# email: admin@example.com
# password: 111222
docker-compose run php vendor/bin/doctrine dbal:run-sql "INSERT INTO user_session (uuid) VALUES ('00000000-0000-0000-0000-000000000000');"
docker-compose run php vendor/bin/doctrine dbal:run-sql "INSERT INTO user (uuid, username, email, password, status, level) VALUES ('00000000-0000-0000-0000-000000000000', 'admin', 'admin@example.com', '4b60602435c81eca6516601b68219c37f93de49c1192660aaa16066070e23b352fb0578b30cb588bb416b5138f03511a809f8b6610d20d90bf72d2a4d9e9548e06cd3eec8ed6', 'work', 'admin');"
