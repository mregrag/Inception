#!/bin/bash

# while ! mysqladmin ping -h"mariadb" --silent; do
#     echo "Waiting for MariaDB to be ready..."
#     sleep 1
# done
#
if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp core download --allow-root

    wp config create --allow-root \
	--dbname=$MYSQL_DATABASE \
	--dbuser=$MYSQL_USER \
	--dbpass=$MYSQL_PASSWORD \
	--dbhost=mariadb \
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
	--user_pass=$WP_PASSWORD \
	--role=author

    wp theme install twentytwentyfour --activate --allow-root

    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root

    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm7.4 -F
