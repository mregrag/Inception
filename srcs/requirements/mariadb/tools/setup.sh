#!/bin/bash

set -e

if [ ! -s "/run/secrets/db_password" ] || [ ! -r "/run/secrets/db_password" ]; then
    echo "Error: Database password secret file is missing, empty, or not readable" >&2
    exit 1
fi

if [ -z "$DB_NAME" ]; then
    echo "Error: DB_NAME is not set or empty" >&2
    exit 1
fi

if [ -z "$DB_USER" ]; then
    echo "Error: DB_USER is not set or empty" >&2
    exit 1
fi

DB_PASSWORD=$(cat /run/secrets/db_password)

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

exec mysqld --bind-address=0.0.0.0 --port=3306 --user=mysql
