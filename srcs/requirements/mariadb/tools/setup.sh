#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)

: "${DB_NAME:?DB_NAME is not set}"
: "${DB_USER:?DB_USER is not set}"
: "${DB_PASSWORD:?DB_PASSWORD is not set}"

service mariadb start

echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping --silent; do
    sleep 1
done


echo "MariaDB is ready."

mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mariadb -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

service mariadb stop

exec mariadbd --bind-address=0.0.0.0 --port=3306 --user=mysql
