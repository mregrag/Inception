#!/bin/sh

if [ -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB database is already initialized."
    exec mysqld --user=mysql
    exit 0
fi

# Initialize MariaDB data directory
echo "Initializing MariaDB data directory..."
mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

echo "Starting MariaDB to configure..."
mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Create database and users
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Set root password and allow remote connections
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "MariaDB configuration completed."

echo "Starting MariaDB server..."
exec mysqld --user=mysql
