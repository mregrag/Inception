#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

: "${DB_NAME:?Error: DB_NAME is not set}"
: "${DB_USER:?Error: DB_USER is not set}"
: "${DB_PASSWORD:?Error: DB_PASSWORD is not set}"
: "${DB_SERVER:?Error: DB_SERVER is not set}"
: "${DOMAIN_NAME:?Error: DOMAIN_NAME is not set}"
: "${WP_TITLE:?Error: WP_TITLE is not set}"
: "${WP_ADMIN_USER:?Error: WP_ADMIN_USER is not set}"
: "${WP_ADMIN_PASSWORD:?Error: WP_ADMIN_PASSWORD is not set}"
: "${WP_ADMIN_EMAIL:?Error: WP_ADMIN_EMAIL is not set}"
: "${WP_USER:?Error: WP_USER is not set}"
: "${WP_EMAIL:?Error: WP_EMAIL is not set}"
: "${WP_USER_PASSWORD:?Error: WP_USER_PASS is not set}"

if [[ "$WP_ADMIN_USER" =~ [Aa]dmin|[Aa]dministrator ]]; then
  echo "ERROR: username contains forbidden word (admin/administrator)."
  exit 1
fi


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
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_EMAIL

  wp user create --allow-root \
    $WP_USER \
    $WP_EMAIL \
    --user_pass=$WP_USER_PASSWORD \
    --role=author

  wp theme install twentytwentyfour --activate --allow-root

  wp plugin install redis-cache --activate --allow-root
  wp config set WP_REDIS_HOST redis --allow-root
  wp config set WP_REDIS_PORT 6379 --raw --allow-root
  wp redis enable --allow-root

  chown -R www-data:www-data /var/www/html
fi

exec php-fpm7.4 -F
