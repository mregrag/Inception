#!/bin/bash

set -e

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

: ${MYSQL_DATABASE:?MYSQL_DATABASE environment variable is not set}
: ${MYSQL_USER:?MYSQL_USER environment variable is not set}

if [ -z "$DB_USER_PASSWORD" ]; then
    echo "db_user_password secret file is empty"
    exit 1
fi

if [ -z "$DB_ROOT_PASSWORD" ]; then
    echo "db_root_password secret file is empty"
    exit 1
fi

if [ ! -d "/var/lib/mysql" ]; then

    echo "Initializing database volume"

    mysql_install_db --user=mysql

    mysqld_safe --user=mysql & pid="$!"

    while ! mysqladmin ping -hlocalhost --silent; do
        echo "Waiting for MariaDB temporary server to start"
        sleep 1
    done

    echo "Temporary server started Configuring database"

    mysql -u root <<EOF
    CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
    GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD'; 
    FLUSH PRIVILEGES;
EOF
    mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
    wait "$pid"

else
    echo "Database volume already exists"
fi

echo "Starting MariaDB in foreground"

exec "$@"
