#!/bin/bash

echo "starting..."

# Create and setup folders
chmod -R 0777 $PWD/var

# Clone repo with engine
echo "clone engine"
git clone -q -b master https://github.com/0x12f/platform.git $PWD/engine

# Install libs composer
echo "install engine libs"
docker run --rm --interactive --tty --volume $PWD/engine:/app composer install --quiet --no-interaction --no-dev

# Run Docker container
echo "starting docker"
docker-compose up -d

# Create database schemes
echo "work with database"
docker-compose run php vendor/bin/doctrine orm:schema-tool:create

# Make database file writable
chmod 0777 $PWD/var/database.sqlite

echo "create admin user"
# create admin user
# login: admin
# email: admin@example.com
# password: 111222
docker-compose run php vendor/bin/doctrine dbal:run-sql "INSERT INTO user_session (uuid) VALUES ('00000000-0000-0000-0000-000000000000');"
docker-compose run php vendor/bin/doctrine dbal:run-sql "INSERT INTO user (uuid, username, email, password, status, level) VALUES ('00000000-0000-0000-0000-000000000000', 'admin', 'admin@example.com', '4b60602435c81eca6516601b68219c37f93de49c1192660aaa16066070e23b352fb0578b30cb588bb416b5138f03511a809f8b6610d20d90bf72d2a4d9e9548e06cd3eec8ed6', 'work', 'admin');"

# Save current engine version into file
cd engine && git log -n1 --pretty='%h' > ../var/version.txt

echo "done"
