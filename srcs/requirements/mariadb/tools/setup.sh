#!/bin/bash

set -e

if [ ! -s "/run/secrets/db_password" ]; then
    echo "Error: Database password secret file is missing or empty" >&2
    exit 1
fi

if [ ! -r "/run/secrets/db_password" ]; then
    echo "Error: Database password secret file is not readable" >&2
    exit 1
fi

DB_PASSWORD=$(cat /run/secrets/db_password)

if [ -z "$MYSQL_DATABASE" ]; then
    echo "Error: MYSQL_DATABASE environment variable is not set" >&2
    exit 1
fi

if [ -z "$MYSQL_USER" ]; then
    echo "Error: MYSQL_USER environment variable is not set" >&2
    exit 1
fi

if [ -z "$MYSQL_DATABASE" ]; then
    echo "Error: MYSQL_DATABASE is empty" >&2
    exit 1
fi

if [ -z "$MYSQL_USER" ]; then
    echo "Error: MYSQL_USER is empty" >&2
    exit 1
fi

service mariadb start

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping --silent; do
    sleep 1
done

echo "MariaDB is ready."

mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}"
mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mariadb -e "GRANT ALL ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

service mariadb stop

exec mysqld --bind-address=0.0.0.0 --port=3306 --user=mysql
