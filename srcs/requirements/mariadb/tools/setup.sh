#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)

service mariadb start

echo "Waiting for MariaDB to be ready..."
until mariadb -e "SELECT 1" > /dev/null 2>&1; do
  sleep 1
done
echo "MariaDB is ready."

mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}"
mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mariadb -e "GRANT ALL ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"
mysqladmin shutdown -u root
exec mysqld --bind-address=0.0.0.0 --port=3306 --user=mysql
