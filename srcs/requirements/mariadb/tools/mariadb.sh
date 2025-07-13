#!/bin/bash
set -euo pipefail

MYSQL_DATADIR=/var/lib/mysql

# One‑time initialisation test
if [ ! -d "$MYSQL_DATADIR/mysql" ]; then
    echo "Initializing system tables …"
    mysql_install_db --user=mysql --ldata="$MYSQL_DATADIR"
fi

# ---------- start temp server ----------
echo "Starting temporary MariaDB server …"
mysqld --user=mysql --skip-networking &
pid="$!"

# Wait until the socket is ready
for i in {1..30}; do
    mysqladmin ping --silent && break
    sleep 1
done

# ---------- initial SQL ----------
mysql -uroot <<SQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
SQL

# ---------- shutdown temp server ----------
mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "Launching final MariaDB server …"
exec mysqld --user=mysql

