#!/bin/bash
set -e

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
REDIS_PASSWORD=$(cat /run/secrets/redis_password)

if [ -z "$DB_USER_PASSWORD" ]; then echo "db_user_password secret is empty"; exit 1; fi
if [ -z "$WP_ADMIN_PASSWORD" ]; then echo "wp_admin_password secret is empty"; exit 1; fi
if [ -z "$WP_USER_PASSWORD" ]; then echo "wp_user_password secret is empty"; exit 1; fi
if [ -z "$REDIS_PASSWORD" ]; then echo "redis_password secret is empty"; exit 1; fi

: "${WP_DB_HOST:?WP_DB_HOST needs to be set}"
: "${MYSQL_USER:?MYSQL_USER needs to be set}"
: "${MYSQL_DATABASE:?MYSQL_DATABASE needs to be set}"
: "${DOMAIN_NAME:?DOMAIN_NAME needs to be set}"
: "${WP_ADMIN_USER:?WP_ADMIN_USER needs to be set}"
: "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL needs to be set}"
: "${WP_USER:?WP_USER needs to be set}"
: "${WP_USER_EMAIL:?WP_USER_EMAIL needs to be set}"

ADMIN_USER_LOWER=$(echo "$WP_ADMIN_USER" | tr '[:upper:]' '[:lower:]')
if [[ "$ADMIN_USER_LOWER" == *"admin"* || "$ADMIN_USER_LOWER" == *"administrator"* ]]; then
    echo "Invalid administrator username '$WP_ADMIN_USER' must not contain 'admin'"
    exit 1
fi

echo "Waiting for MariaDB"
while ! mysqladmin ping -h"$WP_DB_HOST" -u"$MYSQL_USER" -p"$DB_USER_PASSWORD" --silent; do
	echo "MariaDB not ready"
	sleep 2
done
echo "MariaDB port is ready"

if [ ! -f "wp-config.php" ]; then

    wp core download --allow-root

    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_USER_PASSWORD" \
        --dbhost="$WP_DB_HOST"


    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="Inception Project" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create --allow-root \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD"

        wp theme install twentytwentyfour --activate --allow-root

        wp config set WP_REDIS_HOST redis --allow-root
        wp config set WP_REDIS_PORT 6379 --allow-root
        wp config set WP_REDIS_PASSWORD "$REDIS_PASSWORD" --allow-root
        wp config set WP_CACHE_KEY_SALT "$DOMAIN_NAME" --allow-root

        wp plugin install redis-cache --activate --allow-root
        wp redis enable --allow-root

        echo "WordPress installation complete"

else
        echo "WordPress is already installed"
fi

chown -R www-data:www-data /var/www/html 
chmod -R 775 /var/www/html

exec "$@"
