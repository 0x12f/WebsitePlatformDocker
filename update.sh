#!/bin/bash

echo "starting..."

# shutdown docker
echo "stoping docker..."
docker-compose down

# hard reset all changes
echo "update current repo..."
git reset --hard

# update current repo
git pull -f

# Update engine repo
echo "update engine"
cd engine && git reset --hard && git pull -f && cd ..

# Install libs composer
echo "update engine libs"
docker run --rm --interactive --tty --volume $PWD/engine:/app composer update --quiet --no-interaction --no-dev

# Run Docker container
echo "starting docker"
docker-compose up -d

# Create database schemes
echo "work with database"
docker-compose run php vendor/bin/doctrine orm:schema-tool:update --force

# Make database file writable
chmod 0777 $PWD/var/database.sqlite

# Save current engine version into file
cd engine && git log -n1 --pretty='%h' > ../var/version_hash.txt && git describe --exact-match --tags $(git log -n1 --pretty='%h') > ../var/version_tag.txt

echo "done"
