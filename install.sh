#!/bin/bash

git submodule update --init --merge --remote
$PWD/composer install
chmod 0777 $PWD/var -R
chmod 0777 $PWD/engine/public/uploads -R
docker-compose up -d
docker-compose run php vendor/bin/doctrine orm:schema-tool:create
chmod 0777 $PWD/var/database.sqlite

# create admin user
# login: admin
# email: admin@example.com
# password: 111222
docker-compose run php vendor/bin/doctrine dbal:run-sql "INSERT INTO user_session (uuid) VALUES ('00000000-0000-0000-0000-000000000000');"
docker-compose run php vendor/bin/doctrine dbal:run-sql "INSERT INTO user (uuid, username, email, password, status, level) VALUES ('00000000-0000-0000-0000-000000000000', 'admin', 'admin@example.com', '4b60602435c81eca6516601b68219c37f93de49c1192660aaa16066070e23b352fb0578b30cb588bb416b5138f03511a809f8b6610d20d90bf72d2a4d9e9548e06cd3eec8ed6', 'work', 'admin');"
