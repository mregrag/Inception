#!/bin/bash

set -e

for secret in db_password wp_admin_password wp_user_password; do
    if [ ! -s "/run/secrets/$secret" ] || [ ! -r "/run/secrets/$secret" ]; then
        echo "Error: Secret file /run/secrets/$secret is missing, empty, or not readable" >&2
        exit 1
    fi
done

if [ -z "$DB_NAME" ]; then
    echo "ERROR: DB_NAME is not set!" >&2
    exit 1
fi

if [ -z "$DB_USER" ]; then
    echo "ERROR: DB_USER is not set!" >&2
    exit 1
fi

if [ -z "$DB_SERVER" ]; then
    echo "ERROR: DB_SERVER is not set!" >&2
    exit 1
fi

if [ -z "$DOMAIN_NAME" ]; then
    echo "ERROR: DOMAIN_NAME is not set!" >&2
    exit 1
fi

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp core download --allow-root

    wp config create --allow-root \
	--dbname=$DB_NAME \
	--dbuser=$DB_USER \
	--dbpass=$DB_PASSWORD \
	--dbhost=$DB_SERVER \
	--path=/var/www/html

    wp core install --allow-root \
	--url=$DOMAIN_NAME \
	--title=$WP_TITLE \
	--admin_user=$WP_ADMIN_USER \
	--admin_password=$WP_ADMIN_PASS \
	--admin_email=$WP_ADMIN_EMAIL

    wp user create --allow-root \
	$WP_USER \
	$WP_EMAIL \
	--user_pass=$WP_USER_PASS \
	--role=author

    wp theme install twentytwentyfour --activate --allow-root

    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp redis enable --allow-root

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm7.4 -F
